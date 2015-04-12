package main

import (
	"net/http"

	"github.com/codegangsta/negroni"
	"github.com/parisianninjas/mybudget/datastore"
	"github.com/parisianninjas/mybudget/handlers"

	"github.com/unrolled/secure"

	_ "github.com/lib/pq"
)

//create a secure middleware. see https://github.com/unrolled/secure
var secureMiddleware = secure.New(secure.Options{
	FrameDeny:             true,
	ContentTypeNosniff:    true,
	BrowserXssFilter:      true,
	ContentSecurityPolicy: "default-src 'self'",
})

func main() {

	//init datasotre
	datastore.Connect(true, false)
	defer datastore.Close()

	//define routes
	m := http.NewServeMux()
	m.Handle("/api/", http.StripPrefix("/api", handlers.HandleAPI()))
	m.Handle("/", handlers.HandleWEB())

	//create negroni middleware
	n := negroni.New()
	n.Use(negroni.NewRecovery())
	n.Use(negroni.NewLogger())

	//add security
	n.Use(negroni.HandlerFunc(secureMiddleware.HandlerFuncWithNext))

	//add static content from public folder, index.html, seo files and favicon
	//n.Use(negroni.NewStatic(http.Dir("public")))

	//add application handlers
	n.UseHandler(m)

	//running the server
	n.Run(":8000")
}
