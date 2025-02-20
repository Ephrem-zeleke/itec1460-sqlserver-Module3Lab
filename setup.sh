#!/bin/bash

# creating a shortcut for running SQL queries
alias sqlq='sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -Q'

# save the alias permanently in my environment 
echo "alias sqlq='sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -Q'" >> ~/.bashrc