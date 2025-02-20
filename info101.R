library(ggplot2)
library(marinecs100b)

# Demo from notes
# How to create a data frame manually
noaa_survey <- data.frame(latitude = c(45, 45, 30, 30),
                           depth_m = c(5, 100, 5, 100),
                           temp_c = c(10.6, 7.1, 21.8, 18.3))
# Print data frame directly to the console
noaa_survey

# View() function to use RStudio's viewer
View(noaa_survey)

# Alternatively, we can import using read.csv()
write.csv(noaa_survey, "noaa_survey.csv", row.names = FALSE)

# Check the contents of your directory
dir()

# Read a data frame from a CSV file
noaa_survey2 <- read.csv("noaa_survey.csv")
noaa_survey2

# How to see and modify column names
colnames(noaa_survey2)
colnames(noaa_survey2) <- c("Latitude", "DepthM", "TempC")
noaa_survey2


# Questionable organization choices ---------------------------------------

# P1 Call the function dir() at the console. This lists the files in your
# project's directory. Do you see woa.csv in the list? (If you don't, move it to
# the right place before proceeding.)


# P2 Critique the organization of woa.csv according to the characteristics of
# tidy data. The data is not rectangular, does not have consistent names and
# formats, and is definitely confusing the computer and also confusing me :)


# Importing data ----------------------------------------------------------

# P3 Call read.csv() on woa.csv. What error message do you get? What do you
# think that means?
read.csv("woa.csv")
# It says there is an error in read.table probably because the data is so
# horribly organized that R doesn't know what to do with it.

# P4 Re-write the call to read.csv() to avoid the error in P3.
read.csv("woa.csv", skip = 1) # skip = 1 skips the first row so that the data
# can be rectangular


# Fix the column names ----------------------------------------------------

# P5 Fill in the blanks below to create a vector of the depth values.

depths <- c(
  seq(0, 100, by = 5),
  seq(125, 500, by = 25),
  seq(550, 2000, by = 50),
  seq(2100, 5500, by = 100)
)


# P6 Create a vector called woa_colnames with clean names for all 104 columns.
# Make them the column names of your WOA data frame.
woa_colnames <- depths
woa_colnames


# Analyzing wide-format data ----------------------------------------------

# P7 What is the mean water temperature globally in the twilight zone (200-1000m
# depth)?
woa <- read.csv("woa.csv", skip = 1)
woa_twilight <- woa[,25:47]
sum_woa_twilight <- sum(woa_twilight, na.rm = TRUE)
mean_temp_twilight <- ((sum_woa_twilight)/((47-25)*(40566-3)))
#40566-3 is how many rows there are
mean_temp_twilight #6.718066

mean_temp_twilight_2 <- (sum_woa_twilight)/(nrow(woa_twilight)*ncol(woa_twilight))
mean_temp_twilight_2 #6.425818

# Analyzing long-format data ----------------------------------------------

# P8 Using woa_long, find the mean water temperature globally in the twilight zone.
View(woa_long)
twilight_temps <- woa_long[woa_long$depth_m >= 200 & woa_long$depth_m <= 1000, 4]
twilight_temps
mean(twilight_temps) #6.573227

# P9 Compare and contrast your solutions to P7 and P8. Long format gives us a
# more accurate mean. Not sure why P7 gives us two different answers depending
# on what we plug in to find rows and columns. Maybe one takes into account more
# than it should or vice versa, I'm not really sure. Wide format is probably
# just more confusing and R doesn't know what to do.

# P10 Create a variable called mariana_temps. Filter woa_long to the rows in the
# location nearest to the coordinates listed in the in-class instructions.
mariana_lat <- woa_long[woa_long$latitude == 11.5, ]
mariana_long <- woa_long[woa_long$longitude == 142.5, ]
mariana_lat
mariana_temps <- woa_long[woa_long$latitude == 11.5 & woa_long$longitude == 142.5, ]
mariana_temps

# P11 Interpret your temperature-depth profile. What's the temperature at the
# surface? How about in the deepest parts? Over what depth range does
# temperature change the most? Temperature decreases as you increase in depth
# which would make sense. At the surface it is 28.65 C and in the deepest parts is
# 1.53 C. Temperature ranges the most in the tope 450 feet.

# ggplot is a tool for making figures, you'll learn its details in COMM101
ggplot(mariana_temps, aes(temp_c, depth_m)) +
  geom_path() +
  scale_y_reverse()
ggsave("mariana_temps.png")
