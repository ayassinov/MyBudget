package main

import (
	"net/http"

	"github.com/codegangsta/negroni"
	"github.com/parisianninjas/mybudget/datastore"
	"github.com/parisianninjas/mybudget/handlers"

	_ "github.com/lib/pq"
)

func main() {

	datastore.Connect(true, false)
	defer datastore.Close()

	m := http.NewServeMux()
	m.Handle("/api/", http.StripPrefix("/api", handlers.HandleAPI()))

	n := negroni.Classic()
	n.UseHandler(m)
	n.Run(":8000")
}
