package main

import (
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, " + r.URL.Path[1:]))
	})

	host := ":1337"
	log.Println("Listening on", host)
	log.Fatal(http.ListenAndServe(host, nil))
}
