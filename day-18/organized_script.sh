#!/bin/bash

# Variables

USER_NAME="Prantonia"

# Functions

greet() {
    echo "Hello, $USER_NAME"
}

show_date() {
    date
}


# Main Script

greet
show_date
