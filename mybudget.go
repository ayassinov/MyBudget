package main


import (

	"github.com/coopernurse/gorp"
	_ "github.com/mattn/go-sqlite3"
	_ "github.com/lib/pq"
	"database/sql"
	"log"
	//"./entity/User"

)


func main() {
	// initialize the DbMap
	dbmap := initDb()
	defer dbmap.Db.Close()


	// use convenience SelectInt
	var user = &User{1, 1, 1, "Hello", "hello", "yassine@hello.com"}
	dbmap.Insert(user)



	count, err := dbmap.SelectInt("select count(*) from users")
	checkErr(err, "select count(*) failed")
	log.Println("Rows after inserting:", count)

	log.Println("Done!")
}

type User struct {
	Id      int64
	Created int64
	Updated int64
	FName   string
	LName   string
	Email   string
}


func initDb() *gorp.DbMap {

	var db *sql.DB
	var err error
	// connect to db using standard Go database/sql API
	// use whatever database/sql driver you wish
	db, err = sql.Open("postgres", "user=postgres dbname=mybudget2 host=localhost password=root sslmode=disable")

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

