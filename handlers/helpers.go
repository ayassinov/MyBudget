package handlers

import (
	"encoding/json"
	"log"
	"net/http"
)

// writeJSON writes a JSON Content-Type header and a JSON-encoded object to the
// http.ResponseWriter.
func writeJSON(w http.ResponseWriter, v interface{}) error {
	// Indent the JSON so it's easier to read for hackers.
	data, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}

	w.Header().Set("content-type", "application/json; charset=utf-8")
	_, err = w.Write(data)
	return err
}

// checkErr is convient function that check the error and log the message
func checkErr(err error, msg string) error {
	if err != nil {
		log.Fatalln(msg, err)
	}
	return err
}
