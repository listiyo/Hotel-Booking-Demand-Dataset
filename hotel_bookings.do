/* hotel_bookings.csv 
data source : https://www.kaggle.com/jessemostipak/hotel-booking-demand
https://www.sciencedirect.com/science/article/pii/S2352340918315191
*/
macro define DATASETRAW "D:\Google Drive listiyo.data\! Project Data\1 datasetraw"
macro define READYTOANALYZE "D:\Google Drive listiyo.data\! Project Data\3 readytoanalize"
macro define TEMPDTA "D:\temp_\dta"

clear
*import delimit using "$DATASETRAW\hotel_bookings.csv"
*save "$TEMPDTA\hotel_bookings.dta", replace
use  "$TEMPDTA\hotel_bookings.dta"
*
label var hotel "Hotel (H1 = Resort Hotel or H2 = City Hotel)"
label var is_canceled "Value indicating if the booking was canceled (1) or not (0)"
label var lead_time "Number of days that elapsed between the entering date of the booking into the PMS and the arrival date"
label var arrival_date_year "Year of arrival date"
label var arrival_date_month "Month of arrival date"
label var arrival_date_week_number "Week number of year for arrival date"
label var arrival_date_day_of_month "Day of arrival date"
label var stays_in_weekend_nights "Number of weekend nights (Saturday or Sunday) the guest stayed or booked to stay at the hotel"
label var stays_in_week_nights "Number of week nights (Monday to Friday) the guest stayed or booked to stay at the hotel"
label var adults "Number of adults"
label var children "Number of children"
label var babies "Number of babies"
label var meal "Type of meal booked. Categories are presented in standard hospitality meal packages: Undefined/SC – no meal package; BB – Bed & Breakfast; HB – Half board (breakfast and one other meal – usually dinner); FB – Full board (breakfast, lunch and dinner)"
label var country "Country of origin. Categories are represented in the ISO 3155–3:2013 format"
label var market_segment "Market segment designation. In categories, the term “TA” means “Travel Agents” and “TO” means “Tour Operators”"
label var distribution_channel "Booking distribution channel. The term “TA” means “Travel Agents” and “TO” means “Tour Operators”"
label var is_repeated_guest "Value indicating if the booking name was from a repeated guest (1) or not (0)"
label var previous_cancellations "Number of previous bookings that were cancelled by the customer prior to the current booking"
label var previous_bookings_not_canceled "Number of previous bookings not cancelled by the customer prior to the current booking"
label var reserved_room_type "Code of room type reserved. Code is presented instead of designation for anonymity reasons."
label var assigned_room_type "Code for the type of room assigned to the booking. Sometimes the assigned room type differs from the reserved room type due to hotel operation reasons (e.g. overbooking) or by customer request. Code is presented instead of designation for anonymity reasons."
label var booking_changes "Number of changes/amendments made to the booking from the moment the booking was entered on the PMS until the moment of check-in or cancellation"
label var deposit_type "Indication on if the customer made a deposit to guarantee the booking. This variable can assume three categories: No Deposit – no deposit was made; Non Refund – a deposit was made in the value of the total stay cost; Refundable – a deposit was made with a value under the total cost of stay."
label var agent "ID of the travel agency that made the booking"
label var company "ID of the company/entity that made the booking or responsible for paying the booking. ID is presented instead of designation for anonymity reasons"
label var days_in_waiting_list "Number of days the booking was in the waiting list before it was confirmed to the customer"
label var customer_type "Type of booking, assuming one of four categories:Contract - when the booking has an allotment or other type of contract associated to it; Group – when the booking is associated to a group; Transient – when the booking is not part of a group or contract, and is not associated to other transient booking; Transient-party – when the booking is transient, but is associated to at least other transient booking"
label var adr "Average Daily Rate as defined by dividing the sum of all lodging transactions by the total number of staying nights"
label var required_car_parking_spaces "Number of car parking spaces required by the customer"
label var total_of_special_requests "Number of special requests made by the customer (e.g. twin bed or high floor)"
label var reservation_status "Reservation last status, assuming one of three categories: Canceled – booking was canceled by the customer; Check-Out – customer has checked in but already departed; No-Show – customer did not check-in and did inform the hotel of the reason why"
label var reservation_status_date "Date at which the last status was set. This variable can be used in conjunction with the ReservationStatus to understand when was the booking canceled or when did the customer checked-out of the hotel"
*
label define IS_CANCELED 1"Cancel" 0"OK"
label values is_canceled IS_CANCELED
*
replace meal = "1" if meal=="SC"
replace meal = "1" if meal=="Undefined"
replace meal = "2" if meal=="BB"
replace meal = "3" if meal=="HB"
replace meal = "4" if meal=="FB"
destring meal, replace
label define MEAL 1"No meal package" 2"Bed & Breakfast" 3"Half board (breakfast and one other meal – usually dinner)" 4"Full board (breakfast, lunch and dinner)"
label values meal MEAL
*
label define IS_REPEATED_GUEST 1"Yes" 0"No"
label values is_repeated_guest IS_REPEATED_GUEST
*
order arrival_date_day_of_month , after(arrival_date_month )
*
tostring arrival_date_year arrival_date_day_of_month , replace
gen arrival_date_month_n=""
replace arrival_date_month_n = "04" if arrival_date_month=="April"
replace arrival_date_month_n = "08" if arrival_date_month=="August"
replace arrival_date_month_n = "12" if arrival_date_month=="December"
replace arrival_date_month_n = "02" if arrival_date_month=="February"
replace arrival_date_month_n = "01" if arrival_date_month=="January"
replace arrival_date_month_n = "07" if arrival_date_month=="July"
replace arrival_date_month_n = "06" if arrival_date_month=="June"
replace arrival_date_month_n = "03" if arrival_date_month=="March"
replace arrival_date_month_n = "05" if arrival_date_month=="May"
replace arrival_date_month_n = "11" if arrival_date_month=="November"
replace arrival_date_month_n = "10" if arrival_date_month=="October"
replace arrival_date_month_n = "09" if arrival_date_month=="September"
replace arrival_date_day_of_month = "0" + arrival_date_day_of_month if length(trim(arrival_date_day_of_month))==1
gen arrival_date = arrival_date_year + "-" + arrival_date_month_n + "-" + arrival_date_day_of_month 
*
replace children = "0" if children =="NA" 
destring children , replace
*x
gen check = "update! " + c(current_date) + " " +  c(current_time) in 1
xcompress
export excel "$READYTOANALYZE/hotel_bookings.xlsx", first(varlabels) replace 


