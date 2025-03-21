import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

class EditItemPage extends StatefulWidget {
  final int itemId;
  const EditItemPage({super.key, required this.itemId});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic> _itemData = {};
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  final TextEditingController _remainingLifeController = TextEditingController();

  // UOM dropdown
  String _selectedUom = '1';
  List<String> _uomOptions = ['1', '2', '3', '4'];
  Map<String, String> _uomLabels = {
    '1': 'Piece',
    '2': 'Kilogram',
    '3': 'Liter',
    '4': 'Meter'
  };

  // Active status
  String _activeStatus = 'active';
  List<String> _statusOptions = ['active', 'inactive'];

  @override
  void initState() {
    super.initState();
    _fetchItemData();

    // Listen for changes
    _nameController.addListener(_onFormChanged);
    _priceController.addListener(_onFormChanged);
    _categoryController.addListener(_onFormChanged);
    _batchNumberController.addListener(_onFormChanged);
    _manufacturerController.addListener(_onFormChanged);
    _usageController.addListener(_onFormChanged);
    _remainingLifeController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _batchNumberController.dispose();
    _manufacturerController.dispose();
    _usageController.dispose();
    _remainingLifeController.dispose();
    super.dispose();
  }

  Future<void> _fetchItemData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _itemData = data;
          _isLoading = false;
        });

        // Populate text controllers
        _nameController.text = _itemData['item_name'] ?? '';
        _priceController.text = _itemData['price']?.toString() ?? '';
        _categoryController.text = _itemData['category'] ?? '';
        _batchNumberController.text = _itemData['batch_number'] ?? '';
        _manufacturerController.text = _itemData['manufacturer'] ?? '';
        _usageController.text = _itemData['usage'] ?? '';
        _remainingLifeController.text = _itemData['remaining_life'] ?? '';

        // Set dropdown values
        setState(() {
          _selectedUom = _itemData['uom_id'] ?? '1';
          _activeStatus = _itemData['active_flag'] ?? 'active';
        });

        _hasChanges = false;
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load item data (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Network error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedData = {
        'item_name': _nameController.text,
        'price': _priceController.text,
        'category': _categoryController.text,
        'batch_number': _batchNumberController.text,
        'manufacturer': _manufacturerController.text,
        'usage': _usageController.text,
        'remaining_life': _remainingLifeController.text,
        'uom_id': _selectedUom,
        'active_flag': _activeStatus,
      };

      final response = await http.put(
        Uri.parse('https://uat.goclaims.in/inventory_hub/items/${widget.itemId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      setState(() {
        _isSaving = false;
      });

      if (response.statusCode == 200) {
        setState(() {
          _hasChanges = false;
        });
        _showSuccessSnackBar('Item updated successfully');
      } else {
        _showErrorSnackBar('Failed to update item (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard changes?'),
              content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('DISCARD'),
                ),
              ],
            ),
          );
          return result ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Edit Item',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh data',
                onPressed: _fetchItemData,
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: LinearProgressIndicator(
              value: _isLoading ? null : 1.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.primaryContainer,
              ),
            ),
          ),
        ),
        body: _isLoading
            ? _buildLoadingShimmer()
            : _buildEditForm(theme),
        bottomNavigationBar: _isLoading
            ? null
            : _buildBottomBar(theme),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            8,
                (index) => Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100 + (index * 20) % 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Item summary card
            if (!_isLoading && _itemData.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ID: #${widget.itemId} · ${_categoryController.text}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            _buildSectionHeader('Basic Item Information', theme),

            _buildTextFieldWithAnimation(
              controller: _nameController,
              label: 'Item Name',
              icon: Icons.inventory_2_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),

            _buildDoubleField(
              first: _buildTextFieldWithAnimation(
                controller: _priceController,
                label: 'Price',
                icon: Icons.attach_money_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixText: '₹ ',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid price';
                  }
                  return null;
                },
              ),
              second: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedUom,
                  decoration: InputDecoration(
                    labelText: 'Unit of Measure',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    icon: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.straighten_rounded,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  items: _uomOptions.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(_uomLabels[unit] ?? "UOM $unit"),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedUom = newValue;
                        _hasChanges = true;
                      });
                    }
                  },
                ),
              ),
            ),

            _buildSectionHeader('Classification', theme),

            _buildTextFieldWithAnimation(
              controller: _categoryController,
              label: 'Category',
              icon: Icons.category_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category';
                }
                return null;
              },
            ),

            _buildTextFieldWithAnimation(
              controller: _manufacturerController,
              label: 'Manufacturer',
              icon: Icons.business_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter manufacturer';
                }
                return null;
              },
            ),

            _buildSectionHeader('Additional Details', theme),

            _buildTextFieldWithAnimation(
              controller: _batchNumberController,
              label: 'Batch Number',
              icon: Icons.qr_code_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter batch number';
                }
                return null;
              },
            ),

            _buildTextFieldWithAnimation(
              controller: _usageController,
              label: 'Usage',
              icon: Icons.home_repair_service_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter usage';
                }
                return null;
              },
            ),

            _buildTextFieldWithAnimation(
              controller: _remainingLifeController,
              label: 'Remaining Life',
              icon: Icons.timelapse_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter remaining life';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Status card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _activeStatus == 'active'
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _activeStatus == 'active'
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _activeStatus == 'active'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _activeStatus == 'active'
                            ? Icons.toggle_on_rounded
                            : Icons.toggle_off_rounded,
                        size: 28,
                        color: _activeStatus == 'active'
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Item Status',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _activeStatus == 'active'
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _activeStatus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: Icon(
                          _activeStatus == 'active'
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: _activeStatus == 'active'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      items: _statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            status == 'active' ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: status == 'active' ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _activeStatus = newValue;
                            _hasChanges = true;
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24,
                width: 4,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithAnimation({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
          prefixText: prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, size: 16),
            onPressed: () {
              controller.clear();
              _onFormChanged();
            },
          )
              : null,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildDoubleField({
    required Widget first,
    required Widget second,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: 16),
          Expanded(child: second),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 16,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '#${widget.itemId}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (_hasChanges)
            Expanded(
              child: Text(
                'Unsaved changes',
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),
          ElevatedButton.icon(
            onPressed: _hasChanges && !_isSaving ? _updateItem : null,
            icon: _isSaving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.save_rounded),
            label: Text(
              _isSaving ? 'Saving...' : 'Save Changes',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}