import 'package:flutter/material.dart';

// Model class for Manufacturer
class Manufacturer {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String phone;
  final String address;
  final String logo;
  final String category;

  Manufacturer({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.phone,
    required this.address,
    this.logo = '',
    this.category = 'Medical Supplies',
  });
}

class ManufacturerListPage extends StatefulWidget {
  const ManufacturerListPage({super.key});

  @override
  State<ManufacturerListPage> createState() => _ManufacturerListPageState();
}

class _ManufacturerListPageState extends State<ManufacturerListPage> {
  final List<Manufacturer> manufacturers = [
    // Indian Manufacturers
    Manufacturer(
      id: "1",
      name: "Cipla Ltd.",
      contact: "Umang Vohra",
      email: "contact@cipla.com",
      phone: "+91 22 2482 6000",
      address: "Cipla House, Peninsula Business Park, Mumbai, Maharashtra 400013",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "2",
      name: "Sun Pharmaceutical Industries Ltd.",
      contact: "Dilip Shanghvi",
      email: "info@sunpharma.com",
      phone: "+91 22 4324 4324",
      address: "Sun House, CTS No. 201 B/1, Western Express Highway, Goregaon (E), Mumbai 400063",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "3",
      name: "Dr. Reddy's Laboratories",
      contact: "G V Prasad",
      email: "contact@drreddys.com",
      phone: "+91 40 4900 2900",
      address: "8-2-337, Road No. 3, Banjara Hills, Hyderabad, Telangana 500034",
      category: "Pharmaceuticals",
    ),
    Manufacturer(
      id: "4",
      name: "Hindustan Syringes & Medical Devices Ltd.",
      contact: "Rajiv Nath",
      email: "info@hmdhealthcare.com",
      phone: "+91 129 4070000",
      address: "175/1 Bhai Mohan Singh Nagar, Faridabad, Haryana 121004",
      category: "Medical Devices",
    ),
    Manufacturer(
      id: "5",
      name: "Poly Medicure Ltd.",
      contact: "Himanshu Baid",
      email: "info@polymedicure.com",
      phone: "+91 120 429 2100",
      address: "Plot No. 105, 106, Sector 59, Faridabad, Haryana 121004",
      category: "Medical Devices",
    ),
    Manufacturer(
      id: "6",
      name: "Trivitron Healthcare",
      contact: "G.S.K. Velu",
      email: "info@trivitron.com",
      phone: "+91 44 6630 1000",
      address: "15, Jawaharlal Nehru Road, Ekkattuthangal, Chennai, Tamil Nadu 600032",
      category: "Medical Equipment",
    ),
    Manufacturer(
      id: "7",
      name: "BPL Medical Technologies",
      contact: "Sunil Khurana",
      email: "info@bplmedicaltechnologies.com",
      phone: "+91 80 2839 5963",
      address: "11th KM, Bannerghatta Road, Arakere, Bengaluru, Karnataka 560076",
      category: "Medical Equipment",
    ),
    Manufacturer(
      id: "8",
      name: "Transasia Bio-Medicals Ltd.",
      contact: "Suresh Vazirani",
      email: "info@transasia.co.in",
      phone: "+91 22 4040 8000",
      address: "Transasia House, 8 Chandivali Studio Road, Mumbai, Maharashtra 400072",
      category: "Diagnostics",
    ),
    Manufacturer(
      id: "9",
      name: "J Mitra & Co. Pvt. Ltd.",
      contact: "Jatin Mahajan",
      email: "info@jmitra.co.in",
      phone: "+91 11 4567 7777",
      address: "A-180, Okhla Industrial Area, Phase-1, New Delhi 110020",
      category: "Diagnostics",
    ),
    Manufacturer(
      id: "10",
      name: "Stryker India Pvt. Ltd.",
      contact: "Ram Rangarajan",
      email: "india.info@stryker.com",
      phone: "+91 124 4964 100",
      address: "8th Floor, Building 9A, DLF Cyber City, Gurgaon, Haryana 122002",
      category: "Orthopaedic Devices",
    ),
    Manufacturer(
      id: "11",
      name: "Paramount Surgimed Ltd.",
      contact: "Shaily Grover",
      email: "info@paramountsurgimed.com",
      phone: "+91 11 4567 9999",
      address: "66, Sector 25, Phase II, Faridabad, Haryana 121004",
      category: "Surgical Instruments",
    ),
    Manufacturer(
      id: "12",
      name: "Romsons Scientific & Surgical Industries Pvt. Ltd.",
      contact: "Pawan Sharma",
      email: "info@romsons.com",
      phone: "+91 120 2770 001",
      address: "51, Sector 27-C, Mathura Road, Faridabad, Haryana 121003",
      category: "Disposable Medical Supplies",
    ),
    Manufacturer(
      id: "13",
      name: "Meril Life Sciences Pvt. Ltd.",
      contact: "Sanjeev Bhatt",
      email: "info@merillife.com",
      phone: "+91 265 2646 300",
      address: "Survey No. 135/139, Bilakhia House, Muktanand Marg, Vadodara, Gujarat 390015",
      category: "Cardiovascular Devices",
    ),
    Manufacturer(
      id: "14",
      name: "Narang Medical Ltd.",
      contact: "Vijay Narang",
      email: "narang@narang.com",
      phone: "+91 11 4559 5900",
      address: "Narang Tower, 23 Rajindra Place, New Delhi 110008",
      category: "Hospital Furniture",
    ),
    Manufacturer(
      id: "15",
      name: "TTK Healthcare Ltd.",
      contact: "T T Jagannathan",
      email: "info@ttkhealthcare.com",
      phone: "+91 44 2831 0000",
      address: "No. 6, Cathedral Road, Chennai, Tamil Nadu 600086",
      category: "Reproductive Healthcare",
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get categories {
    final Set<String> uniqueCategories = manufacturers.map((m) => m.category).toSet();
    return ['All', ...uniqueCategories.toList()..sort()];
  }

  List<Manufacturer> get filteredManufacturers {
    return manufacturers.where((manufacturer) {
      final matchesSearch = manufacturer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          manufacturer.contact.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || manufacturer.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manufacturers",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (_searchQuery.isNotEmpty)
                    Chip(
                      label: Text('Search: $_searchQuery'),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                  if (_selectedCategory != 'All')
                    Chip(
                      label: Text('Category: $_selectedCategory'),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedCategory = 'All';
                        });
                      },
                    ),
                ],
              ),
            ),
          Expanded(
            child: filteredManufacturers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No manufacturers found',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredManufacturers.length,
              itemBuilder: (context, index) {
                final manufacturer = filteredManufacturers[index];
                return ManufacturerCard(manufacturer: manufacturer);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Manufacturer'),
        backgroundColor: Colors.teal,
        onPressed: () {
          // Add manufacturer logic
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Manufacturers'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter manufacturer name or contact',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: categories.map((category) {
              return RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class ManufacturerCard extends StatelessWidget {
  final Manufacturer manufacturer;

  const ManufacturerCard({
    super.key,
    required this.manufacturer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(manufacturer.category).withOpacity(0.2),
          child: Icon(
            _getCategoryIcon(manufacturer.category),
            color: _getCategoryColor(manufacturer.category),
          ),
        ),
        title: Text(
          manufacturer.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              manufacturer.contact,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Chip(
              label: Text(
                manufacturer.category,
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
              backgroundColor: _getCategoryColor(manufacturer.category),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                _buildManufacturerInfo(
                  Icons.email_outlined,
                  "Email",
                  manufacturer.email,
                  context,
                ),
                const SizedBox(height: 12),
                _buildManufacturerInfo(
                  Icons.phone_outlined,
                  "Phone",
                  manufacturer.phone,
                  context,
                ),
                const SizedBox(height: 12),
                _buildManufacturerInfo(
                  Icons.location_on_outlined,
                  "Address",
                  manufacturer.address,
                  context,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal,
                      ),
                      onPressed: () {
                        // Implement edit functionality
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        // Show delete confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text(
                              'Are you sure you want to delete ${manufacturer.name}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Implement actual delete functionality
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManufacturerInfo(
      IconData icon,
      String label,
      String value,
      BuildContext context,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pharmaceuticals':
        return Colors.blue;
      case 'Medical Devices':
        return Colors.green;
      case 'Medical Equipment':
        return Colors.purple;
      case 'Diagnostics':
        return Colors.orange;
      case 'Surgical Instruments':
        return Colors.red;
      case 'Orthopaedic Devices':
        return Colors.teal;
      case 'Disposable Medical Supplies':
        return Colors.indigo;
      case 'Cardiovascular Devices':
        return Colors.pink;
      case 'Hospital Furniture':
        return Colors.amber.shade800;
      case 'Reproductive Healthcare':
        return Colors.cyan.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Pharmaceuticals':
        return Icons.medication;
      case 'Medical Devices':
        return Icons.medical_services;
      case 'Medical Equipment':
        return Icons.monitor_heart;
      case 'Diagnostics':
        return Icons.biotech;
      case 'Surgical Instruments':
        return Icons.cut;
      case 'Orthopaedic Devices':
        return Icons.accessibility_new;
      case 'Disposable Medical Supplies':
        return Icons.sanitizer;
      case 'Cardiovascular Devices':
        return Icons.favorite;
      case 'Hospital Furniture':
        return Icons.chair;
      case 'Reproductive Healthcare':
        return Icons.pregnant_woman;
      default:
        return Icons.factory;
    }
  }
}