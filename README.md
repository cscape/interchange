# Interchange

This project is the first (and only) fully-automated installer for [TheTransitClock](https://github.com/TheTransitClock/transitime), designed to make launching it as easy and effortless as possible. See [Why](#why)

## Usage

### Pre-Setup

- Download the latest version of [Ubuntu](https://ubuntu.com/download) or [Debian](https://www.debian.org/distrib/)
- Install Docker: `curl -sSL https://get.docker.com/ | sh`
- Install [Git](https://git-scm.com/download)
- Download Interchange: `git clone https://github.com/cscape/interchange.git`
- Navigate to the Interchange directory: `cd interchange`

### Interchange Setup

In the `agencies` directory, you'll find an example of how to configure transit agencies to work in Interchange. The name of the files don't matter, but they *must* end in `.env` so the installer knows what to look for.

Each configuration file corresponds to 1 transit agency. Each one must have an ID (without spaces), a link to a [GTFS](https://developers.google.com/transit/gtfs/) feed, and a link to a [**GTFS Realtime Vehicle Positions**](https://developers.google.com/transit/gtfs-realtime/guides/vehicle-positions) feed. Each one must be double quoted as follows. Here's an example of a configuration file:

```sh
ID="tampa-regional-transit"
GTFS="http://www.gohart.org/google/google_transit.zip"
GTFSRT="http://api.tampa.onebusaway.org:8088/vehicle-positions"
```

### Running Interchange

```sh
. go.sh
```

The start script will build an Interchange container (may take up to 20 minutes), start the PostgreSQL database, create database tables for each transit agency, load the gtfs data into the database, create an API key, and deploy the API + Web service.

The API is available at `http://localhost:3020/api`  
The Web interface is at `http://localhost:3020/web`

## Why?

[TheTransitClock](https://github.com/TheTransitClock/transitime) is a big workhorse that basically turns vehicle positions (AVL/GPS data) into trip updates for transit agencies. This is extremely useful for generating arrival times at stops and metro stations, and **critical** for having realtime data on Google Maps. *The problem is that TheTransitClock is confusing to set up.* After about 3 months of trial-and-error, and 4 variations of Wayline Interchange, this is the final result that works. So far, it's worked very well and this is now a breeze to use.

## License

[MIT](LICENSE) © [Cyberscape](https://cyberscape.co/).
