package main

import (
	"net/http"
	"os"
	"fmt"
	"github.com/gorilla/mux"
	"github.com/codegangsta/negroni"
)

var (
	port string
	n *negroni.Negroni
	r *mux.Router
)

func main() {
	loadParameters()
	configRoutes()
	addMiddleWare()
	runServer()
}

func configRoutes() {
	r := mux.NewRouter().StrictSlash(false)
	r.HandleFunc("/", defaultHandler)

	// Posts collection
	posts := r.Path("/categories").Subrouter()
	posts.Methods("GET").HandlerFunc(defaultHandler)
	posts.Methods("POST").HandlerFunc(defaultHandler)

	// Posts singular
	post := r.PathPrefix("/categories/{id}").Subrouter()
	post.Methods("GET").Path("/edit").HandlerFunc(defaultHandler)
	post.Methods("GET").HandlerFunc(defaultHandler)
	post.Methods("PUT", "POST").HandlerFunc(defaultHandler)
	post.Methods("DELETE").HandlerFunc(defaultHandler)
}

func addMiddleWare() {
	n := negroni.Classic()
	n.Use(negroni.HandlerFunc(printAnyIdVarMiddleware))
	n.UseHandler(r)
}

func runServer() {
	fmt.Println("Starting server on :", port)
	http.ListenAndServe(":"+port, n)
}

func defaultHandler(rw http.ResponseWriter, r *http.Request) {
	fmt.Println("vars", mux.Vars(r)["id"])

	rw.Write([]byte("hello GUYS"))
}

func handleDefaultResponse(rw http.ResponseWriter, r *http.Request) {
	rw.Write([]byte("hello GUYS"))
}

func printAnyIdVarMiddleware(rw http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	idValue := mux.Vars(r)["id"]
	if (idValue != "") {
		fmt.Println("Path id value is:", idValue)
	}

	next(rw, r)
}

func loadParameters() {
	port = os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
}
