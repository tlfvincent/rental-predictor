# rental-predictor
Application to visualize and forecast rental prices in different neighborhoods


## Running the app
If you are working locally, you can simply type the following into your R console:
```
library(shiny)
runApp('app/')
```

If you are working on a remote machine and would like to reproduce the app on a host, make sure you have `Docker` installed on your system and type the following:

```
docker build -t name_of_your_image .
```

followed by

```
docker run -p 4000:4000 -ti name_of_your_image
```

The app should then be publicly visible at the following URL `http://your_machine_ip:4000/app/`

The `your_machine_ip` value can be found by using the command `hostname -I`.