package main

import (
	"fmt"
	"log"
	"net/http"
	"github.com/coopernurse/gorp"
	_ "github.com/mattn/go-sqlite3"
	_ "github.com/lib/pq"
	"database/sql"
	"github.com/gorilla/mux"
	"encoding/json"
)


type User struct {
	Id      int64
	Created int64
	Updated int64
	FName   string
	LName   string
	Email   string
}

type users []User

func main() {

	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", Index)
	router.HandleFunc("/users", getAllUsers)
	router.HandleFunc("/todos/{todoId}", TodoShow)

	log.Fatal(http.ListenAndServe(":8080", router))
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "what did you expect :p ")
}

func getAllUsers(w http.ResponseWriter, r *http.Request) {
	// initialize the DbMap
	dbmap := initDb()
	defer dbmap.Db.Close()

	count, err := dbmap.SelectInt("select count(*) from users")
	checkErr(err, "select count(*) failed")
	log.Println("Rows after inserting:", count)

	users := make([]User, int(count), 15)

	var dd []User
	_, err = dbmap.Select(&dd, "SELECT * FROM users")

	checkErr(err, "Select failed")

	n := 0
	for _, user := range dd {
		users[n] = User{Id:user.Id,Created:user.Created,Updated:user.Updated,FName:user.FName,LName:user.LName,Email:user.Email}
		log.Println("Last name Nom : ",user.LName,"",user.FName)
		n++
	}

	json.NewEncoder(w).Encode(users)
}

func TodoShow(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	todoId := vars["todoId"]
	fmt.Fprintln(w, "Todo show:", todoId)
}


func initDb() *gorp.DbMap {

	var db *sql.DB
	var err error
	// connect to db using standard Go database/sql API
	// use whatever database/sql driver you wish
	db, err = sql.Open("postgres", "user=postgres dbname=mybudget host=localhost password=postgres sslmode=disable")

	checkErr(err, "sql.Open failed")

	// construct a gorp DbMap
	dbmap := &gorp.DbMap{Db: db, Dialect: gorp.PostgresDialect{}}

	// add a table, setting the table name to 'user' and
	// specifying that the Id property is an auto incrementing PK
	dbmap.AddTableWithName(User{}, "users").SetKeys(true, "Id")

	// create the table. in a production system you'd generally
	// use a migration tool, or create the tables via scripts
	err = dbmap.CreateTablesIfNotExists()
	checkErr(err, "Create tables failed")

	return dbmap
}



func checkErr(err error, msg string) {
	if err != nil {
		log.Fatalln(msg, err)
	}
}
