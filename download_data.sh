#!/bin/sh

rm ./app/data/Neighborhood_MedianRentalPrice_Studio.csv
rm ./app/data/Neighborhood_MedianRentalPrice_1Bedroom.csv
rm ./app/data/Neighborhood_MedianRentalPrice_2Bedroom.csv
rm ./app/data/Neighborhood_MedianRentalPrice_3Bedroom.csv
rm ./app/data/Neighborhood_MedianRentalPrice_4Bedroom.csv

wget http://files.zillowstatic.com/research/public/Neighborhood/Neighborhood_MedianRentalPrice_Studio.csv -O ./app/data/Neighborhood_MedianRentalPrice_Studio.csv
wget http://files.zillowstatic.com/research/public/Neighborhood/Neighborhood_MedianRentalPrice_1Bedroom.csv -O ./app/data/Neighborhood_MedianRentalPrice_1Bedroom.csv
wget http://files.zillowstatic.com/research/public/Neighborhood/Neighborhood_MedianRentalPrice_2Bedroom.csv -O ./app/data/Neighborhood_MedianRentalPrice_2Bedroom.csv
wget http://files.zillowstatic.com/research/public/Neighborhood/Neighborhood_MedianRentalPrice_3Bedroom.csv -O ./app/data/Neighborhood_MedianRentalPrice_3Bedroom.csv
wget http://files.zillowstatic.com/research/public/Neighborhood/Neighborhood_MedianRentalPrice_4Bedroom.csv -O ./app/data/Neighborhood_MedianRentalPrice_4Bedroom.csv