
const List<String> cities = [
  'Adilabad', 'Agra', 'Ahmedabad', 'Ahmednagar', 'Aizawl', 'Ajitgarh', 'Ajmer', 'Akola', 'Alappuzha',
  'Aligarh', 'Alirajpur', 'Allahabad', 'Almora', 'Alwar', 'Ambala', 'Ambedkar Nagar', 'Amravati',
  'Amreli district', 'Amritsar', 'Anand', 'Anantapur', 'Anantnag', 'Angul', 'Anjaw', 'Anuppur', 'Araria',
  'Ariyalur', 'Arwal', 'Ashok Nagar', 'Auraiya', 'Aurangabad', 'Aurangabad', 'Azamgarh', 'Badgam', 'Bagalkot',
  'Bageshwar', 'Bagpat', 'Bahraich', 'Baksa', 'Balaghat', 'Balangir', 'Balasore', 'Ballia', 'Balrampur',
  'Banaskantha', 'Banda', 'Bandipora', 'Bangalore Rural', 'Bangalore Urban', 'Banka', 'Bankura', 'Banswara',
  'Barabanki', 'Baramulla', 'Baran', 'Bardhaman', 'Bareilly', 'Bargarh', 'Barmer', 'Barnala', 'Barpeta',
  'Barwani', 'Bastar', 'Basti', 'Bathinda', 'Beed', 'Begusarai', 'Belgaum', 'Bellary', 'Betul', 'Bhadrak',
  'Bhagalpur', 'Bhandara', 'Bharatpur', 'Bharuch', 'Bhavnagar', 'Bhilwara', 'Bhind', 'Bhiwani', 'Bhojpur',
  'Bhopal', 'Bidar', 'Bijapur', 'Bijapur', 'Bijnor', 'Bikaner', 'Bilaspur', 'Birbhum', 'Bishnupur', 'Bokaro',
  'Bongaigaon', 'Boudh', 'Budaun', 'Bulandshahr', 'Buldhana', 'Bundi', 'Burhanpur', 'Buxar', 'Cachar',
  'Central Delhi', 'Chamarajnagar', 'Chamba', 'Chamoli', 'Champawat', 'Champhai', 'Chandauli', 'Chandel',
  'Chandigarh', 'Chandrapur', 'Changlang', 'Chatra', 'Chennai', 'Chhatarpur', 'Chhatrapati Shahuji Maharaj Nagar',
  'Chhindwara', 'Chikkaballapur', 'Chikkamagaluru', 'Chirang', 'Chitradurga', 'Chitrakoot', 'Chittoor',
  'Chittorgarh', 'Churachandpur', 'Churu', 'Coimbatore', 'Cooch Behar', 'Cuddalore', 'Cuttack', 'Dadra and Nagar Haveli',
  'Dahod', 'Dakshin Dinajpur', 'Dakshina Kannada', 'Daman', 'Damoh', 'Dantewada', 'Darbhanga', 'Darjeeling',
  'Darrang', 'Datia', 'Dausa', 'Davanagere', 'Debagarh', 'Dehradun', 'Deoghar', 'Deoria', 'Dewas', 'Dhalai',
  'Dhamtari', 'Dhanbad', 'Dhar', 'Dharmapuri', 'Dharwad', 'Dhemaji', 'Dhenkanal', 'Dholpur', 'Dhubri',
  'Dhule', 'Dibang Valley', 'Dibrugarh', 'Dima Hasao', 'Dimapur', 'Dindigul', 'Dindori', 'Diu', 'Doda',
  'Dumka', 'Dungapur', 'Durg', 'East Champaran', 'East Delhi', 'East Garo Hills', 'East Khasi Hills', 'East Siang',
  'East Sikkim', 'East Singhbhum', 'Eluru', 'Ernakulam', 'Erode', 'Etah', 'Etawah', 'Faizabad', 'Faridabad',
  'Faridkot', 'Farrukhabad', 'Fatehabad', 'Fatehgarh Sahib', 'Fatehpur', 'Fazilka', 'Firozabad', 'Firozpur',
  'Gadag', 'Gadchiroli', 'Gajapati', 'Ganderbal', 'Gandhinagar', 'Ganganagar', 'Ganjam', 'Garhwa', 'Gautam Buddh Nagar',
  'Gaya', 'Ghaziabad', 'Ghazipur', 'Giridih', 'Goalpara', 'Godda', 'Golaghat', 'Gonda', 'Gondia', 'Gopalganj',
  'Gorakhpur', 'Gulbarga', 'Gumla', 'Guna', 'Guntur', 'Gurdaspur', 'Gurgaon', 'Gwalior', 'Hailakandi', 'Hamirpur',
  'Hanumangarh', 'Harda', 'Hardoi', 'Haridwar', 'Hassan', 'Haveri district', 'Hazaribag', 'Hingoli', 'Hissar',
  'Hooghly', 'Hoshangabad', 'Hoshiarpur', 'Howrah', 'Hyderabad', 'Idukki', 'Imphal East', 'Imphal West', 'Indore',
  'Jabalpur', 'Jagatsinghpur', 'Jaintia Hills', 'Jaipur', 'Jaisalmer', 'Jajpur', 'Jalandhar', 'Jalaun', 'Jalgaon',
  'Jalna', 'Jalore', 'Jalpaiguri', 'Jammu', 'Jamnagar', 'Jamtara', 'Jamui', 'Janjgir-Champa', 'Jashpur',
  'Jaunpur district', 'Jehanabad', 'Jhabua', 'Jhajjar', 'Jhalawar', 'Jhansi', 'Jharsuguda', 'Jhunjhunu', 'Jind',
  'Jodhpur', 'Jorhat', 'Junagadh', 'Jyotiba Phule Nagar', 'Kabirdham', 'Kadapa', 'Kaimur', 'Kaithal', 'Kakinada',
  'Kalahandi', 'Kamrup', 'Kamrup Metropolitan', 'Kanchipuram', 'Kandhamal', 'Kangra', 'Kanker', 'Kannauj', 'Kannur',
  'Kanpur', 'Kanshi Ram Nagar', 'Kanyakumari', 'Kapurthala', 'Karaikal', 'Karauli', 'Karbi Anglong', 'Kargil', 'Karimganj',
  'Karimnagar', 'Karnal', 'Karur', 'Kasaragod', 'Kathua', 'Katihar', 'Katni', 'Kaushambi', 'Kendrapara', 'Kendujhar',
  'Khagaria', 'Khammam', 'Khandwa (East Nimar)', 'Khargone (West Nimar)', 'Kheda', 'Khordha', 'Khowai', 'Khunti',
  'Kinnaur', 'Kishanganj', 'Kishtwar', 'Kodagu', 'Koderma', 'Kohima', 'Kokrajhar', 'Kolar', 'Kolasib', 'Kolhapur',
  'Kolkata', 'Kollam', 'Koppal', 'Koraput', 'Korba', 'Koriya', 'Kota', 'Kottayam', 'Kozhikode', 'Krishna', 'Kulgam',
  'Kullu', 'Kupwara', 'Kurnool', 'Kurukshetra', 'Kurung Kumey', 'Kushinagar', 'Kutch', 'Lahaul and Spiti', 'Lakhimpur',
  'Lakhimpur Kheri', 'Lakhisarai', 'Lalitpur', 'Latehar', 'Latur', 'Lawngtlai', 'Leh', 'Lohardaga', 'Lohit', 'Lower Dibang Valley',
  'Lower Subansiri', 'Lucknow', 'Ludhiana', 'Lunglei', 'Madhepura', 'Madhubani', 'Madurai', 'Mahamaya Nagar', 'Maharajganj',
  'Mahasamund', 'Mahbubnagar', 'Mahe', 'Mahendragarh', 'Mahoba', 'Mainpuri', 'Malappuram', 'Maldah', 'Malkangiri',
  'Mamit', 'Mandi', 'Mandla', 'Mandsaur', 'Mandya', 'Mansa', 'Marigaon', 'Mathura', 'Mau', 'Mayurbhanj', 'Medak',
  'Meerut', 'Mehsana', 'Mewat', 'Mirzapur', 'Moga', 'Mokokchung', 'Mon', 'Moradabad', 'Morena', 'Mumbai City', 'Mumbai suburban',
  'Munger', 'Murshidabad', 'Muzaffarnagar', 'Muzaffarpur', 'Mysore', 'Nabarangpur', 'Nadia', 'Nagaon', 'Nagapattinam',
  'Nagaur', 'Nainital', 'Nalanda', 'Nalbari', 'Nalgonda', 'Namakkal', 'Nanded', 'Nandurbar', 'Narayanpur', 'Narmada',
  'Narsinghpur', 'Nashik', 'Navsari', 'Nawada', 'Nawanshahr', 'Nayagarh', 'Neemuch', 'Nellore', 'New Delhi', 'Nilgiris',
  'Nizamabad', 'North Delhi', 'North East Delhi', 'North Goa', 'North Sikkim', 'North Tripura', 'North West Delhi',
  'Nuapada', 'Ongole', 'Osmanabad', 'Pakur', 'Palakkad', 'Palamu', 'Pali', 'Palwal', 'Panchkula', 'Panchmahal', 'Panipat',
  'Panna', 'Papum Pare', 'Parbhani', 'Paschim Medinipur', 'Patan', 'Pathanamthitta', 'Pathankot', 'Patiala', 'Patna',
  'Pauri Garhwal', 'Perambalur', 'Phek', 'Pilibhit', 'Pithoragarh', 'Pondicherry', 'Poonch', 'Porbandar', 'Pratapgarh',
  'Pratapgarh', 'Pudukkottai', 'Pulwama', 'Pune', 'Purba Medinipur', 'Puri', 'Purnia', 'Purulia', 'Raebareli', 'Raichur',
  'Raigad', 'Raigarh', 'Raipur', 'Raisen', 'Rajauri', 'Rajgarh', 'Rajkot', 'Rajnandgaon', 'Rajsamand', 'Ramabai Nagar',
  'Ramanagara', 'Ramanathapuram', 'Ramban', 'Ramgarh', 'Rampur', 'Ranchi', 'Ratlam', 'Ratnagiri', 'Rayagada', 'Reasi',
  'Rewa', 'Rewari', 'Ri Bhoi', 'Rohtak', 'Rohtas', 'Rudraprayag', 'Rupnagar', 'Sabarkantha', 'Sagar', 'Saharanpur',
  'Saharsa', 'Sahibganj', 'Saiha', 'Salem', 'Samastipur', 'Samba', 'Sambalpur', 'Sangli', 'Sangrur', 'Sant Kabir Nagar',
  'Sant Ravidas Nagar', 'Saran', 'Satara', 'Satna', 'Sawai Madhopur', 'Sehore', 'Senapati', 'Seoni', 'Seraikela Kharsawan',
  'Serchhip', 'Shahdol', 'Shahjahanpur', 'Shajapur', 'Shamli', 'Sheikhpura', 'Sheohar', 'Sheopur', 'Shimla', 'Shimoga',
  'Shivpuri', 'Shopian', 'Shravasti', 'Sibsagar', 'Siddharthnagar', 'Sidhi', 'Sikar', 'Simdega', 'Sindhudurg', 'Singrauli',
  'Sirmaur', 'Sirohi', 'Sirsa', 'Sitamarhi', 'Sitapur', 'Sivaganga', 'Siwan', 'Solan', 'Solapur', 'Sonbhadra', 'Sonipat',
  'Sonitpur', 'South 24 Parganas', 'South Delhi', 'South Garo Hills', 'South Goa', 'South Sikkim', 'South Tripura',
  'South West Delhi', 'Sri Muktsar Sahib', 'Srikakulam', 'Srinagar', 'Subarnapur', 'Sultanpur', 'Sundergarh', 'Supaul',
  'Surat', 'Surendranagar', 'Surguja', 'Tamenglong', 'Tarn Taran', 'Tawang', 'Tehri Garhwal', 'Thane', 'Thanjavur',
  'The Dangs', 'Theni', 'Thiruvananthapuram', 'Thoothukudi', 'Thoubal', 'Thrissur', 'Tikamgarh', 'Tinsukia', 'Tirap',
  'Tiruchirappalli', 'Tirunelveli', 'Tirupur', 'Tiruvallur', 'Tiruvannamalai', 'Tiruvarur', 'Tonk', 'Tuensang', 'Tumkur',
  'Udaipur', 'Udalguri', 'Udham Singh Nagar', 'Udhampur', 'Udupi', 'Ujjain', 'Ukhrul', 'Umaria', 'Una', 'Unnao',
  'Upper Siang', 'Upper Subansiri', 'Uttar Dinajpur', 'Uttara Kannada', 'Uttarkashi', 'Vadodara', 'Vaishali', 'Valsad',
  'Varanasi', 'Vellore', 'Vidisha', 'Viluppuram', 'Virudhunagar', 'Visakhapatnam', 'Vizianagaram', 'Vyara', 'Warangal',
  'Wardha', 'Washim', 'Wayanad', 'West Champaran', 'West Delhi', 'West Garo Hills', 'West Kameng', 'West Khasi Hills',
  'West Siang', 'West Sikkim', 'West Singhbhum', 'West Tripura', 'Wokha', 'Yadgir', 'Yamuna Nagar', 'Yanam', 'Yavatmal',
  'Zunheboto'
];

const List<String> states = [
  'Andaman and Nicobar Islands', 'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chandigarh',
  'Chhattisgarh', 'Delhi', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Jharkhand',
  'Karnataka', 'Kerala', 'Ladakh', 'Lakshadweep', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
  'Mizoram', 'Nagaland', 'Odisha', 'Puducherry', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana',
  'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
];

const List<String> countries = [
  'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria',
  'Azerbaijan', 'The Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
  'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon',
  'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Democratic Republic of the Congo',
  'Republic of the Congo', 'Costa Rica', 'Côte d’Ivoire', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic', 'Denmark', 'Djibouti', 'Dominica',
  'Dominican Republic', 'East Timor (Timor-Leste)',  'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia',
  'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'The Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala',
  'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel',
  'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Korea, North', 'Korea, South', 'Kosovo', 'Kuwait', 'Kyrgyzstan',
  'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi', 'Malaysia',
  'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro',
  'Morocco', 'Mozambique', 'Myanmar (Burma)', 'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria',
  'North Macedonia', 'Norway', 'Oman', 'Pakistan', 'Palau', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal',
  'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino',
  'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands',
  'Somalia', 'South Africa', 'Spain', 'Sri Lanka', 'Sudan', 'South Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan',
  'Tanzania', 'Thailand', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates',
  'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
];

const List<String> country_code = [
  '+91 (India)', '+92 (Pakistan)', '+977 (Nepal)', '+94 (Sri Lanka)', '+880 (Bangladesh)', '+975 (Bhutan)', '+86 (China)', '+65 (Singapore)', '+60 (Malaysia)'
      '+62 (Indonesia)', '+63 (Philippines)'
];

class DropDownOption {
  static final List<Map<String, dynamic>> equipmentData = [
    // Diagnostic Equipment
    {
      "category": "diagnostic_equipment",
      "name": "X-ray machines",
      "status": "Available",
      "condition": "Good",
      "description": "Used ~20 times/day for routine imaging",
      "total_equipments": 3,
      "equipments_available": 2
    },
    {
      "category": "diagnostic_equipment",
      "name": "CT scanners",
      "status": "Unavailable",
      "condition": "Fair",
      "description": "High-demand scanner used for ~15 scans/day",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "diagnostic_equipment",
      "name": "MRI machines",
      "status": "Unavailable",
      "condition": "Needs Repair",
      "description": "Requires coil replacement; used heavily in last quarter",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "diagnostic_equipment",
      "name": "Ultrasound machines",
      "status": "Available",
      "condition": "Good",
      "description": "Used ~30 times/day across different departments",
      "total_equipments": 4,
      "equipments_available": 4
    },
    {
      "category": "diagnostic_equipment",
      "name": "Fluoroscopy machines",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Used daily for guided imaging procedures (~10/day)",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "diagnostic_equipment",
      "name": "PET scanners",
      "status": "Available",
      "condition": "Good",
      "description": "Specialized imaging, used ~5 times/week",
      "total_equipments": 1,
      "equipments_available": 1
    },
    {
      "category": "diagnostic_equipment",
      "name": "DEXA scanners",
      "status": "Available",
      "condition": "Good",
      "description": "Used ~10 times/week for bone density scans",
      "total_equipments": 1,
      "equipments_available": 1
    },

    // Monitoring Equipment
    {
      "category": "monitoring_equipment",
      "name": "ECG machines",
      "status": "Available",
      "condition": "Good",
      "description": "Used ~40 times/day in cardiology ward",
      "total_equipments": 6,
      "equipments_available": 6
    },
    {
      "category": "monitoring_equipment",
      "name": "EEG machines",
      "status": "Available",
      "condition": "New",
      "description": "Recently installed; used ~5 times/day",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "monitoring_equipment",
      "name": "Pulse oximeters",
      "status": "Available",
      "condition": "Good",
      "description": "Widely used across wards (~100 uses/day total)",
      "total_equipments": 25,
      "equipments_available": 25
    },
    {
      "category": "monitoring_equipment",
      "name": "Cardiac monitors",
      "status": "Unavailable",
      "condition": "Fair",
      "description": "Continuous use in ICU; some units under repair",
      "total_equipments": 8,
      "equipments_available": 0
    },
    {
      "category": "monitoring_equipment",
      "name": "Capnographs",
      "status": "Available",
      "condition": "Good",
      "description": "Used in OR and ICU for CO2 monitoring (~10 uses/day)",
      "total_equipments": 4,
      "equipments_available": 4
    },
    {
      "category": "monitoring_equipment",
      "name": "Blood pressure monitors",
      "status": "Available",
      "condition": "Good",
      "description": "Frequent use across all wards (~200 uses/day)",
      "total_equipments": 50,
      "equipments_available": 50
    },
    {
      "category": "monitoring_equipment",
      "name": "Stethoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Personal equipment for staff; replaced yearly",
      "total_equipments": 100,
      "equipments_available": 100
    },
    {
      "category": "monitoring_equipment",
      "name": "Thermometers",
      "status": "Available",
      "condition": "Good",
      "description": "Multiple types (digital, infrared). High daily usage",
      "total_equipments": 60,
      "equipments_available": 60
    },
    {
      "category": "monitoring_equipment",
      "name": "Glucometers",
      "status": "Available",
      "condition": "Good",
      "description": "Used for bedside glucose checks (~150 tests/day)",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "monitoring_equipment",
      "name": "Otoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used in ENT and pediatrics for ear examinations",
      "total_equipments": 15,
      "equipments_available": 15
    },
    {
      "category": "monitoring_equipment",
      "name": "Ophthalmoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used for routine eye checks (~10 uses/day)",
      "total_equipments": 10,
      "equipments_available": 10
    },

    // Surgical Instruments
    {
      "category": "surgical_instruments",
      "name": "Scalpels",
      "status": "Available",
      "condition": "New",
      "description": "Disposable blades changed after each procedure",
      "total_equipments": 100,
      "equipments_available": 100
    },
    {
      "category": "surgical_instruments",
      "name": "Surgical scissors",
      "status": "Available",
      "condition": "Good",
      "description": "Sterilized after each use, minimal wear",
      "total_equipments": 50,
      "equipments_available": 50
    },
    {
      "category": "surgical_instruments",
      "name": "Hemostats",
      "status": "Available",
      "condition": "Good",
      "description": "High usage in surgeries, regularly sterilized",
      "total_equipments": 75,
      "equipments_available": 75
    },
    {
      "category": "surgical_instruments",
      "name": "Forceps",
      "status": "Available",
      "condition": "Good",
      "description": "Multiple types for various procedures",
      "total_equipments": 80,
      "equipments_available": 80
    },
    {
      "category": "surgical_instruments",
      "name": "Retractors",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Several units sent for sharpening/repair",
      "total_equipments": 20,
      "equipments_available": 0
    },
    {
      "category": "surgical_instruments",
      "name": "Needle holders",
      "status": "Available",
      "condition": "Good",
      "description": "Essential for suturing; replaced as needed",
      "total_equipments": 40,
      "equipments_available": 40
    },
    {
      "category": "surgical_instruments",
      "name": "Suturing instruments",
      "status": "Available",
      "condition": "Good",
      "description": "Various needle types and thread spools",
      "total_equipments": 60,
      "equipments_available": 60
    },
    {
      "category": "surgical_instruments",
      "name": "Electrocautery tools",
      "status": "Available",
      "condition": "Good",
      "description": "Used for ~10 surgeries/day, regularly maintained",
      "total_equipments": 5,
      "equipments_available": 5
    },
    {
      "category": "surgical_instruments",
      "name": "Cryosurgical units",
      "status": "Available",
      "condition": "Fair",
      "description": "Moderate usage for tissue freezing procedures",
      "total_equipments": 2,
      "equipments_available": 2
    },

    // Laparoscopic Instruments
    {
      "category": "laparoscopic_instruments",
      "name": "Laparoscope",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Currently out for maintenance; used ~5/day previously",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "laparoscopic_instruments",
      "name": "Trocars",
      "status": "Available",
      "condition": "New",
      "description": "Disposable tips; replaced after each procedure",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "laparoscopic_instruments",
      "name": "Insufflators",
      "status": "Available",
      "condition": "Good",
      "description": "Used to insufflate abdomen with CO2, ~5 uses/day",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "laparoscopic_instruments",
      "name": "Graspers",
      "status": "Available",
      "condition": "Good",
      "description": "Multiple sets; sterilized after each surgery",
      "total_equipments": 10,
      "equipments_available": 10
    },
    {
      "category": "laparoscopic_instruments",
      "name": "Dissectors",
      "status": "Available",
      "condition": "Good",
      "description": "Used for tissue separation, ~5 uses/day",
      "total_equipments": 10,
      "equipments_available": 10
    },

    // Orthopedic Surgery Instruments
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Bone saws",
      "status": "Available",
      "condition": "Fair",
      "description": "Used in major joint replacement surgeries, blades replaced regularly",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Drills",
      "status": "Available",
      "condition": "Good",
      "description": "Used in fixation surgeries, sanitized after each use",
      "total_equipments": 5,
      "equipments_available": 5
    },
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Osteotomes",
      "status": "Available",
      "condition": "Good",
      "description": "Used for bone cutting, ~2 times/day",
      "total_equipments": 6,
      "equipments_available": 6
    },
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Bone chisels",
      "status": "Unavailable",
      "condition": "Fair",
      "description": "Most chipped, awaiting replacement or refurbishment",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Bone screws & plates",
      "status": "Available",
      "condition": "New",
      "description": "Variety of sizes, single-use or sterilized if reusable",
      "total_equipments": 100,
      "equipments_available": 100
    },
    {
      "category": "orthopedic_surgery_instruments",
      "name": "Intramedullary rods",
      "status": "Available",
      "condition": "New",
      "description": "Stocked in different lengths, used weekly",
      "total_equipments": 15,
      "equipments_available": 15
    },

    // Life Support Equipment
    {
      "category": "life_support_equipment",
      "name": "Ventilators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "ICU demand is high; currently all in use",
      "total_equipments": 10,
      "equipments_available": 0
    },
    {
      "category": "life_support_equipment",
      "name": "Defibrillators",
      "status": "Available",
      "condition": "Good",
      "description": "Checked daily, used in emergency cases",
      "total_equipments": 8,
      "equipments_available": 8
    },
    {
      "category": "life_support_equipment",
      "name": "Anesthesia machines",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All allocated to operating rooms at the moment",
      "total_equipments": 6,
      "equipments_available": 0
    },
    {
      "category": "life_support_equipment",
      "name": "Dialysis machines",
      "status": "Unavailable",
      "condition": "Fair",
      "description": "Operating in nephrology ward (~5 patients/day each)",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "life_support_equipment",
      "name": "Infusion pumps",
      "status": "Available",
      "condition": "Good",
      "description": "Used hospital-wide for IV therapy (~50 total uses/day)",
      "total_equipments": 25,
      "equipments_available": 25
    },
    {
      "category": "life_support_equipment",
      "name": "Syringe pumps",
      "status": "Available",
      "condition": "Good",
      "description": "Used for precise medication dosing, daily usage",
      "total_equipments": 15,
      "equipments_available": 15
    },
    {
      "category": "life_support_equipment",
      "name": "Suction pumps",
      "status": "Available",
      "condition": "Good",
      "description": "Used in OR and emergency for airway management",
      "total_equipments": 10,
      "equipments_available": 10
    },
    {
      "category": "life_support_equipment",
      "name": "Resuscitation bags",
      "status": "Available",
      "condition": "Good",
      "description": "Portable units, crucial for emergency ventilation",
      "total_equipments": 12,
      "equipments_available": 12
    },
    {
      "category": "life_support_equipment",
      "name": "Oxygen concentrators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All units are currently in patient rooms",
      "total_equipments": 6,
      "equipments_available": 0
    },
    {
      "category": "life_support_equipment",
      "name": "CPAP & BiPAP machines",
      "status": "Available",
      "condition": "Good",
      "description": "Used mainly in respiratory ward for sleep apnea",
      "total_equipments": 5,
      "equipments_available": 5
    },

    // Emergency & Trauma Equipment
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Crash carts",
      "status": "Available",
      "condition": "Good",
      "description": "Fully stocked for code blue situations",
      "total_equipments": 5,
      "equipments_available": 5
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Defibrillators",
      "status": "Available",
      "condition": "Good",
      "description": "Separate units for emergency rooms, tested daily",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Emergency ventilators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Currently in use for critical trauma cases",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Spinal boards",
      "status": "Available",
      "condition": "Good",
      "description": "Used for immobilization in trauma cases",
      "total_equipments": 8,
      "equipments_available": 8
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Cervical collars",
      "status": "Available",
      "condition": "New",
      "description": "Disposable or adjustable collars for neck injuries",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Bandages & splints",
      "status": "Available",
      "condition": "New",
      "description": "Bulk supply for first-aid and trauma management",
      "total_equipments": 200,
      "equipments_available": 200
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Trauma shears",
      "status": "Available",
      "condition": "Good",
      "description": "Used to quickly remove clothing in emergencies",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Tourniquets",
      "status": "Available",
      "condition": "New",
      "description": "Essential for hemorrhage control",
      "total_equipments": 30,
      "equipments_available": 30
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Chest tubes",
      "status": "Unavailable",
      "condition": "New",
      "description": "All used in the OR or ICU for thoracic emergencies",
      "total_equipments": 10,
      "equipments_available": 0
    },
    {
      "category": "emergency_and_trauma_equipment",
      "name": "Trauma stretchers",
      "status": "Available",
      "condition": "Good",
      "description": "Easily portable, used in ER for quick patient transfer",
      "total_equipments": 6,
      "equipments_available": 6
    },

    // Patient Care Equipment
    {
      "category": "patient_care_equipment",
      "name": "Hospital beds",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All occupied at the moment",
      "total_equipments": 200,
      "equipments_available": 0
    },
    {
      "category": "patient_care_equipment",
      "name": "Wheelchairs",
      "status": "Available",
      "condition": "Good",
      "description": "Used for patient mobility, routine maintenance",
      "total_equipments": 50,
      "equipments_available": 50
    },
    {
      "category": "patient_care_equipment",
      "name": "Patient lifts",
      "status": "Available",
      "condition": "Good",
      "description": "Helps transfer patients with limited mobility",
      "total_equipments": 10,
      "equipments_available": 10
    },
    {
      "category": "patient_care_equipment",
      "name": "Overbed tables",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All are currently in use by patients",
      "total_equipments": 150,
      "equipments_available": 0
    },
    {
      "category": "patient_care_equipment",
      "name": "Bedside commodes",
      "status": "Available",
      "condition": "Good",
      "description": "Used by patients with mobility issues",
      "total_equipments": 40,
      "equipments_available": 40
    },
    {
      "category": "patient_care_equipment",
      "name": "IV stands",
      "status": "Available",
      "condition": "Good",
      "description": "Movable stands for fluid/medication drips",
      "total_equipments": 80,
      "equipments_available": 80
    },
    {
      "category": "patient_care_equipment",
      "name": "Infusion poles",
      "status": "Available",
      "condition": "Good",
      "description": "Alternative stands for IV therapy",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "patient_care_equipment",
      "name": "Oxygen therapy units",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All assigned to patients requiring oxygen",
      "total_equipments": 15,
      "equipments_available": 0
    },

    // Laboratory Equipment
    {
      "category": "laboratory_equipment",
      "name": "Blood analyzers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Currently all in use (~200 samples/day)",
      "total_equipments": 3,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "Urinalysis machines",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Busy processing urine samples (~100/day)",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "Centrifuges",
      "status": "Available",
      "condition": "Good",
      "description": "Used across various labs for sample separation",
      "total_equipments": 5,
      "equipments_available": 5
    },
    {
      "category": "laboratory_equipment",
      "name": "Microscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used by lab technicians for slide examination",
      "total_equipments": 10,
      "equipments_available": 10
    },
    {
      "category": "laboratory_equipment",
      "name": "Autoclaves",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All are running sterilization cycles",
      "total_equipments": 3,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "Incubators",
      "status": "Unavailable",
      "condition": "Fair",
      "description": "Both in use for culture growth",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "Biochemistry analyzers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Fully booked with routine tests",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "PCR machines",
      "status": "Available",
      "condition": "New",
      "description": "Used for molecular diagnostics, ~50 tests/day",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "laboratory_equipment",
      "name": "Blood gas analyzers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Both allocated to critical care labs",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "laboratory_equipment",
      "name": "Spectrophotometers",
      "status": "Available",
      "condition": "Good",
      "description": "Used for quantitative analysis of samples",
      "total_equipments": 2,
      "equipments_available": 2
    },

    // Obstetrics & Gynecology Equipment
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Fetal heart monitors",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in labor ward, continuously monitoring",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Doppler ultrasound devices",
      "status": "Available",
      "condition": "Good",
      "description": "Portable units for prenatal check-ups",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Birthing beds",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All occupied in maternity ward",
      "total_equipments": 6,
      "equipments_available": 0
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Speculums",
      "status": "Available",
      "condition": "New",
      "description": "Disposable or sterilizable, used in gynec exams",
      "total_equipments": 50,
      "equipments_available": 50
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Hysteroscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used for intrauterine diagnostics (~10 times/week)",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Colposcopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used in cervical exams, ~5 procedures/week",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Infant warmers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Currently in use for newborns",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Neonatal incubators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Maintains stable environment for preterm infants",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "obstetrics_and_gynecology_equipment",
      "name": "Breast pumps",
      "status": "Available",
      "condition": "Good",
      "description": "Hospital-grade pumps for lactation support",
      "total_equipments": 10,
      "equipments_available": 10
    },

    // Pediatrics & Neonatal Equipment
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Neonatal incubators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in use for NICU patients",
      "total_equipments": 6,
      "equipments_available": 0
    },
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Infant warmers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Used immediately after birth to stabilize infants",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Phototherapy units",
      "status": "Available",
      "condition": "Good",
      "description": "Used for jaundice treatment (~5 sessions/day)",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Apgar scoring equipment",
      "status": "Available",
      "condition": "Good",
      "description": "Standard kit for newborn condition assessment",
      "total_equipments": 4,
      "equipments_available": 4
    },
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Pediatric ventilators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All allocated in pediatric ICU",
      "total_equipments": 3,
      "equipments_available": 0
    },
    {
      "category": "pediatrics_and_neonatal_equipment",
      "name": "Pediatric feeding tubes",
      "status": "Available",
      "condition": "New",
      "description": "Various sizes for nasogastric/nasojejunal feeding",
      "total_equipments": 30,
      "equipments_available": 30
    },

    // Rehabilitation Equipment
    {
      "category": "rehabilitation_equipment",
      "name": "Physical therapy devices",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in use (exercise bikes, treadmills, etc.)",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "rehabilitation_equipment",
      "name": "Parallel bars",
      "status": "Available",
      "condition": "Good",
      "description": "Used for gait training in physiotherapy",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "rehabilitation_equipment",
      "name": "Walkers",
      "status": "Available",
      "condition": "Good",
      "description": "Assists mobility for recovering patients",
      "total_equipments": 20,
      "equipments_available": 20
    },
    {
      "category": "rehabilitation_equipment",
      "name": "Crutches",
      "status": "Available",
      "condition": "Good",
      "description": "Standard and adjustable crutches for short- or long-term use",
      "total_equipments": 30,
      "equipments_available": 30
    },
    {
      "category": "rehabilitation_equipment",
      "name": "TENS machines",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All units are currently out on patient therapy",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "rehabilitation_equipment",
      "name": "Therapy exercise balls",
      "status": "Available",
      "condition": "Good",
      "description": "Used for balance and core strengthening exercises",
      "total_equipments": 10,
      "equipments_available": 10
    },
    {
      "category": "rehabilitation_equipment",
      "name": "Hydrotherapy equipment",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Aquatic therapy pool in use",
      "total_equipments": 1,
      "equipments_available": 0
    },

    // Dental Equipment
    {
      "category": "dental_equipment",
      "name": "Dental chairs",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in use throughout the day for procedures",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "dental_equipment",
      "name": "Dental X-ray machines",
      "status": "Available",
      "condition": "Good",
      "description": "Used ~20 times/day for patient imaging",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "dental_equipment",
      "name": "Handpieces",
      "status": "Available",
      "condition": "Good",
      "description": "High-speed tools, autoclaved between patients",
      "total_equipments": 15,
      "equipments_available": 15
    },
    {
      "category": "dental_equipment",
      "name": "Ultrasonic scalers",
      "status": "Available",
      "condition": "Good",
      "description": "Used for plaque and tartar removal",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "dental_equipment",
      "name": "Dental suction units",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Being serviced to replace tubing",
      "total_equipments": 5,
      "equipments_available": 0
    },
    {
      "category": "dental_equipment",
      "name": "Sterilization units",
      "status": "Available",
      "condition": "Good",
      "description": "Essential for instrument sterilization",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "dental_equipment",
      "name": "Dental impression trays",
      "status": "Available",
      "condition": "New",
      "description": "Disposable trays for molding dental impressions",
      "total_equipments": 50,
      "equipments_available": 50
    },

    // ENT (Ear, Nose, Throat) Equipment
    {
      "category": "ent_equipment",
      "name": "Laryngoscopes",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in surgical use or being sterilized",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "ent_equipment",
      "name": "Sinus endoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used for diagnostic and minor sinus procedures",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "ent_equipment",
      "name": "Rhinoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used in nasal examinations",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "ent_equipment",
      "name": "Tympanometers",
      "status": "Available",
      "condition": "Good",
      "description": "Tests middle ear function, ~10 tests/day",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "ent_equipment",
      "name": "Nasopharyngoscopes",
      "status": "Available",
      "condition": "New",
      "description": "Flexible scopes for nasopharynx examination",
      "total_equipments": 2,
      "equipments_available": 2
    },

    // Ophthalmic Equipment
    {
      "category": "ophthalmic_equipment",
      "name": "Slit lamps",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All allocated to busy clinics (~15 exams/day)",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "ophthalmic_equipment",
      "name": "Tonometers",
      "status": "Available",
      "condition": "Good",
      "description": "Checks intraocular pressure, ~20 tests/day",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "ophthalmic_equipment",
      "name": "Retinoscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Used for refraction tests, ~10/day",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "ophthalmic_equipment",
      "name": "Ophthalmic microscopes",
      "status": "Unavailable",
      "condition": "Good",
      "description": "In use for ongoing eye surgeries",
      "total_equipments": 1,
      "equipments_available": 0
    },
    {
      "category": "ophthalmic_equipment",
      "name": "Fundus cameras",
      "status": "Available",
      "condition": "Good",
      "description": "Retinal imaging, ~10 patients/day",
      "total_equipments": 2,
      "equipments_available": 2
    },

    // Gastroenterology Equipment
    {
      "category": "gastroenterology_equipment",
      "name": "Endoscopes",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in use for upper GI endoscopies (~10 procedures/day)",
      "total_equipments": 4,
      "equipments_available": 0
    },
    {
      "category": "gastroenterology_equipment",
      "name": "Colonoscopes",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Screening and diagnostic usage, ~8/day",
      "total_equipments": 3,
      "equipments_available": 0
    },
    {
      "category": "gastroenterology_equipment",
      "name": "Gastroscopes",
      "status": "Available",
      "condition": "Good",
      "description": "Shared set with endoscopy suite, ~6/day",
      "total_equipments": 3,
      "equipments_available": 3
    },
    {
      "category": "gastroenterology_equipment",
      "name": "Capsule endoscopy devices",
      "status": "Available",
      "condition": "New",
      "description": "Swallowable capsules for GI tract imaging",
      "total_equipments": 10,
      "equipments_available": 10
    },

    // Oncology Equipment
    {
      "category": "oncology_equipment",
      "name": "Linear accelerators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Fully booked for treatment schedules (~20 patients/day)",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "oncology_equipment",
      "name": "Brachytherapy devices",
      "status": "Available",
      "condition": "Good",
      "description": "Internal radiation treatment, scheduled weekly",
      "total_equipments": 1,
      "equipments_available": 1
    },
    {
      "category": "oncology_equipment",
      "name": "Chemotherapy infusion pumps",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All in use in oncology ward",
      "total_equipments": 10,
      "equipments_available": 0
    },
    {
      "category": "oncology_equipment",
      "name": "PET/CT scanners",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Used for staging and follow-up of cancer patients",
      "total_equipments": 1,
      "equipments_available": 0
    },

    // Sterilization & Disinfection Equipment
    {
      "category": "sterilization_and_disinfection_equipment",
      "name": "Autoclaves",
      "status": "Available",
      "condition": "Good",
      "description": "High-temperature steam sterilization",
      "total_equipments": 4,
      "equipments_available": 4
    },
    {
      "category": "sterilization_and_disinfection_equipment",
      "name": "Ultraviolet disinfection systems",
      "status": "Available",
      "condition": "Good",
      "description": "Used for room and equipment disinfection",
      "total_equipments": 2,
      "equipments_available": 2
    },
    {
      "category": "sterilization_and_disinfection_equipment",
      "name": "Ethylene oxide sterilizers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Being used for heat-sensitive equipment sterilization",
      "total_equipments": 1,
      "equipments_available": 0
    },
    {
      "category": "sterilization_and_disinfection_equipment",
      "name": "High-level disinfectants",
      "status": "Available",
      "condition": "New",
      "description": "Chemical disinfectants for endoscopes, instruments",
      "total_equipments": 20,
      "equipments_available": 20
    },

    // Miscellaneous Hospital Equipment
    {
      "category": "miscellaneous_hospital_equipment",
      "name": "Medical waste disposal units",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Processing hospital waste continuously",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "miscellaneous_hospital_equipment",
      "name": "Automated medication dispensers",
      "status": "Unavailable",
      "condition": "Good",
      "description": "All allocated in high-traffic wards",
      "total_equipments": 3,
      "equipments_available": 0
    },
    {
      "category": "miscellaneous_hospital_equipment",
      "name": "Blood refrigerators",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Maintaining cold chain for stored blood products",
      "total_equipments": 2,
      "equipments_available": 0
    },
    {
      "category": "miscellaneous_hospital_equipment",
      "name": "Medical gas systems",
      "status": "Unavailable",
      "condition": "Good",
      "description": "Central supply for O2, N2O, air, vacuum",
      "total_equipments": 1,
      "equipments_available": 0
    },
    {
      "category": "miscellaneous_hospital_equipment",
      "name": "Smart hospital systems",
      "status": "Available",
      "condition": "New",
      "description": "Integration platform for records and remote monitoring",
      "total_equipments": 1,
      "equipments_available": 1
    },
  ];
}
