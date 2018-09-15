package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"googlemaps.github.io/maps"
)

type RideInfo struct {
	Seconds float64
	Meters  int
}

const apiKey = "GOOGLE_MAPS_API_KEY"
const defaultPort = "8000"

func check(err error) {
	if err != nil {
		log.Fatalf("fatal error: %s", err)
		return
	}
}

func main() {
	http.HandleFunc("/ride_info", infoHandler)
	http.ListenAndServe(":"+defaultPort, nil)
}

func infoHandler(w http.ResponseWriter, r *http.Request) {
	key := os.Getenv(apiKey)
	if key == "" {
		log.Printf("Please specify an API Key as environment var")
		os.Exit(1)
	}

	client, err := maps.NewClient(maps.WithAPIKey(key))
	check(err)

	startCoords := r.FormValue("start_coords")
	endCoords := r.FormValue("end_coords")

	request := &maps.DistanceMatrixRequest{
		Origins:      []string{startCoords},
		Destinations: []string{endCoords},
	}
	resp, err := client.DistanceMatrix(context.Background(), request)
	check(err)

	element := resp.Rows[0].Elements[0]
	rideInfo := RideInfo{element.Duration.Seconds(), element.Distance.Meters}
	status := element.Status
	if status != "OK" {
		log.Printf("Status is not ok %s", status)
		return
	}

	info, err := json.Marshal(rideInfo)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(info)
}
