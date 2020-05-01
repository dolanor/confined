package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/{name}", func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		w.Write([]byte("Hello, " + vars["name"]))
	})

	host := ":1337"
	log.Println("Listening on", host)
	log.Fatal(http.ListenAndServe(host, router))
}
