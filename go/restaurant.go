package main

import (
	"log"
    "math/rand"
    "sync"
    "sync/atomic"
    "time"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.

func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

// Implement the rest of the simulation here. You may need to add more imports
// above.

// Order represents a meal order placed by a customer.
type Order struct {
	id        uint64
	customer  string
	reply     chan *Order
	preparedBy string
}

// thread-safe counter used to assign unique IDs to orders
var orderID atomic.Uint64
// representing the waiter who can hold up to 3 outstanding orders
var waiter = make(chan *Order, 3)

// cook takes an order from the waiter then send the completed order back when cooked
func cook(name string) {
	log.Println(name, "starting work")
	for {
		order := <-waiter
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order
	}
}