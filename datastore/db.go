package datastore

import (
	"database/sql"
	"log"
	"os"
	"sync"

	"gopkg.in/gorp.v1"
	//forcing the import of the postgres driver used by gorp
	_ "github.com/lib/pq"
)

// DB is the global database.
var DB *gorp.DbMap

var connectOnce sync.Once

// Connect connects to the PostgreSQL database specified by the PG* environment
// variables. It calls log.Fatal if it encounters an error.
func Connect(isTrace bool, isDropTables bool) {
	connectOnce.Do(func() {
		setDBCredentials()

		db, err := sql.Open("postgres", "user=postgres dbname=mybudget host=localhost password=root sslmode=disable")

		checkErr(err, "sql.Open failed. Error connecting to PostgreSQL database.")

		DB = &gorp.DbMap{Db: db, Dialect: gorp.PostgresDialect{}}

		if isDropTables {
			dropDatabase()
		}

		createabase()

		// Will log all SQL statements + args as they are run
		// The first arg is a string prefix to prepend to all log messages
		if isTrace {
			DB.TraceOn("[gorp]", log.New(os.Stdout, "mybudget:", log.Lmicroseconds))
		}
		// Turn off tracing
		//dbmap.TraceOff()
	})
}

//Close dispose database connection
func Close() {
	if DB != nil && DB.Db != nil {
		DB.Db.Close()
		DB.Db = nil
		DB = nil
	}
}

func createabase() {
	// add a table, setting the table name to 'posts' and
	// specifying that the Id property is an auto incrementing PK
	DB.AddTableWithName(Category{}, "mb_category").SetKeys(true, "ID")

	// create the table. in a production system you'd generally
	// use a migration tool, or create the tables via scripts
	var err = DB.CreateTablesIfNotExists()
	checkErr(err, "Create tables failed")
}

func dropDatabase() error {
	err := DB.DropTables()
	return err
}

func clearAllData() error {
	err := DB.TruncateTables()
	return err
}

func setDBCredentials() {
	//TODO(yab) load database credential from System env.
}

// checkErr is convient function that check the error and log the message
func checkErr(err error, msg string) {
	if err != nil {
		log.Fatalln(msg, err)
	}
}
