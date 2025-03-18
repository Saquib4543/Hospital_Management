// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ServerDataTable extends StatefulWidget {
//   const ServerDataTable({Key? key}) : super(key: key);
//
//   @override
//   _ServerDataTableState createState() => _ServerDataTableState();
// }
//
// class _ServerDataTableState extends State<ServerDataTable> {
//   int _rowsPerPage = 20;
//   int _currentPage = 1;
//   int _totalRecords = 0;
//   List<dynamic> _logs = [];
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       final startIndex = (_currentPage - 1) * _rowsPerPage;
//       final url = Uri.parse('https://uat.goclaims.in/inventory_hub/get_logs');
//
//       final headers = {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       };
//
//       final requestBody = json.encode({
//         "draw": 1, // Sometimes required
//         "length": _rowsPerPage,
//         "start": startIndex
//       });
//
//       final response = await http.post(url, headers: headers, body: requestBody);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           _logs = data["data"];
//           _totalRecords = data["recordsTotal"] ?? data["data"].length;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to load data. Status code: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching data: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Server-Side DataTable'),
//         elevation: 2,
//       ),
//       body: _buildBody(),
//     );
//   }
//
//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (_errorMessage.isNotEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_errorMessage, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _fetchData,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Logs from API',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minWidth: constraints.minWidth,
//                       ),
//                       child: PaginatedDataTable(
//                         header: null,
//                         columns: const [
//                           DataColumn(label: Text('ID')),
//                           DataColumn(label: Text('Details')),
//                           DataColumn(label: Text('Timestamp')),
//                         ],
//                         source: _LogDataSource(_logs),
//                         rowsPerPage: _rowsPerPage,
//                         onRowsPerPageChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               _rowsPerPage = value;
//                               _currentPage = 1;
//                             });
//                             _fetchData();
//                           }
//                         },
//                         availableRowsPerPage: const [10, 30, 50],
//                         onPageChanged: (pageIndex) {
//                           setState(() {
//                             _currentPage = pageIndex + 1;
//                           });
//                           _fetchData();
//                         },
//                         showCheckboxColumn: false,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _LogDataSource extends DataTableSource {
//   final List<dynamic> data;
//
//   _LogDataSource(this.data);
//
//   @override
//   DataRow getRow(int index) {
//     final item = data[index];
//     return DataRow(
//       cells: [
//         DataCell(Text(item['item_id']?.toString() ?? 'N/A')),
//         DataCell(
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 300),
//             child: Text(
//               item['description'] ?? 'N/A',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//         DataCell(Text(item['updated_on'] ?? 'N/A')),
//       ],
//     );
//   }
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => data.length;
//
//   @override
//   int get selectedRowCount => 0;
// }
//
//
//

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LogEntry {
  final String refId;
  final String itemId;
  final String qrId;
  final String locationId;
  final String issuanceStatus;
  final String requestNumber;
  final String fromDate;
  final String toDate;
  final String description;
  final String activeFlag;
  final String createdBy;
  final String updatedOn;

  LogEntry({
    required this.refId,
    required this.itemId,
    required this.qrId,
    required this.locationId,
    required this.issuanceStatus,
    required this.requestNumber,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.activeFlag,
    required this.createdBy,
    required this.updatedOn,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      refId: json['ref_id'] ?? '',
      itemId: json['item_id'] ?? '',
      qrId: json['qr_id'] ?? '',
      locationId: json['location_id'] ?? '',
      issuanceStatus: json['issuance_status'] ?? '',
      requestNumber: json['request_number'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      description: json['description'] ?? '',
      activeFlag: json['active_flag'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedOn: json['updated_on'] ?? '',
    );
  }
}

class LogService {
  static const String apiUrl = "https://uat.goclaims.in/inventory_hub/get_logs";

  Future<Map<String, dynamic>> fetchLogs(int start, int length, String search, String statusFilter) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "draw": 1,
          "start": start,
          "length": length,
          "search": {"value": search},
          "statusFilter": statusFilter,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<LogEntry> logs = (jsonData['data'] as List)
            .map((log) => LogEntry.fromJson(log))
            .toList();

        return {
          "logs": logs,
          "totalRecords": jsonData['recordsTotal'],
        };
      } else {
        throw Exception("Failed to load logs: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching logs: $e");
      return {"logs": [], "totalRecords": 0};
    }
  }
}

class PaginatedLogTable extends StatefulWidget {
  @override
  _PaginatedLogTableState createState() => _PaginatedLogTableState();
}

class _PaginatedLogTableState extends State<PaginatedLogTable> {
  List<LogEntry> logs = [];
  int totalRecords = 0;
  int currentPage = 0;
  int rowsPerPage = 10;
  String searchQuery = "";
  String statusFilter = "All";
  bool isLoading = false;
  bool isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> statusOptions = ["All", "Reserved", "Issued", "Returned", "Damaged"];
  DateTime? fromDateFilter;
  DateTime? toDateFilter;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchLogs() async {
    setState(() => isLoading = true);

    var response = await LogService().fetchLogs(
      currentPage * rowsPerPage,
      rowsPerPage,
      searchQuery,
      statusFilter == "All" ? "" : statusFilter,
    );

    setState(() {
      logs = response["logs"];
      totalRecords = response["totalRecords"];
      isLoading = false;
    });
  }

  void resetFilters() {
    setState(() {
      searchQuery = "";
      statusFilter = "All";
      fromDateFilter = null;
      toDateFilter = null;
      currentPage = 0;
      _searchController.clear();
    });
    fetchLogs();
  }

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Inventory Logs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchLogs,
            tooltip: "Refresh data",
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildFilterSheet(),
              );
            },
            tooltip: "Filter logs",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusFilterChips(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : logs.isEmpty
                ? _buildEmptyState()
                : _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.indigo,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search logs...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    searchQuery = value;
                    currentPage = 0;
                    fetchLogs();
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    searchQuery = "";
                    currentPage = 0;
                    fetchLogs();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: statusOptions.map((status) {
          final isSelected = statusFilter == status;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  statusFilter = status;
                  currentPage = 0;
                });
                fetchLogs();
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.indigo[100],
              checkmarkColor: Colors.indigo,
              labelStyle: TextStyle(
                color: isSelected ? Colors.indigo : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "No logs found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try changing your search or filters",
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text("Reset Filters"),
            onPressed: resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Showing ${logs.length} of $totalRecords logs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      _buildPaginationControls(),
                    ],
                  ),
                ),
                Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                    columns: [
                      DataColumn(label: Text("ITEM ID", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DESCRIPTION", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("FROM DATE", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("TO DATE", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("CREATED BY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("ACTIONS", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: logs.map((log) {
                      return DataRow(
                        cells: [
                          DataCell(Text(log.itemId)),
                          DataCell(_buildStatusBadge(log.issuanceStatus)),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                log.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(Text(formatDate(log.fromDate))),
                          DataCell(Text(formatDate(log.toDate))),
                          DataCell(Text(log.createdBy)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility, color: Colors.blue),
                                  onPressed: () => _showLogDetails(log),
                                  tooltip: "View details",
                                ),
                                IconButton(
                                  icon: Icon(Icons.qr_code, color: Colors.indigo),
                                  onPressed: () => _showQRCode(log),
                                  tooltip: "Show QR code",
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Divider(height: 1),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<int>(
                        value: rowsPerPage,
                        items: [10, 20, 50, 100].map((value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text("$value rows"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              rowsPerPage = value;
                              currentPage = 0;
                            });
                            fetchLogs();
                          }
                        },
                      ),
                      _buildPaginationControls(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status) {
      case "Reserved":
        badgeColor = Colors.orange;
        break;
      case "Issued":
        badgeColor = Colors.green;
        break;
      case "Returned":
        badgeColor = Colors.blue;
        break;
      case "Damaged":
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    int totalPages = (totalRecords / rowsPerPage).ceil();
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
    IconButton(
    icon: Icon(Icons.first_page),
    onPressed: currentPage > 0
    ? () {
    setState(() => currentPage = 0);
    fetchLogs();
    }
        : null,
    tooltip: "First page",
    ),
    IconButton(
    icon: Icon(Icons.chevron_left),
      onPressed: currentPage > 0
          ? () {
        setState(() => currentPage = currentPage - 1);
        fetchLogs();
      }
          : null,
      tooltip: "Previous page",
    ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Page ${currentPage + 1} of $totalPages",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages - 1
                ? () {
              setState(() => currentPage = currentPage + 1);
              fetchLogs();
            }
                : null,
            tooltip: "Next page",
          ),
          IconButton(
            icon: Icon(Icons.last_page),
            onPressed: currentPage < totalPages - 1
                ? () {
              setState(() => currentPage = totalPages - 1);
              fetchLogs();
            }
                : null,
            tooltip: "Last page",
          ),
        ],
    );
  }

  Widget _buildFilterSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter Logs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            resetFilters();
                          },
                          child: Text("Reset"),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            fetchLogs();
                          },
                          child: Text("Apply"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: statusOptions.map((status) {
                        final isSelected = statusFilter == status;
                        return FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              statusFilter = status;
                              currentPage = 0;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.indigo[100],
                          checkmarkColor: Colors.indigo,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Date Range",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: fromDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2026),
                              );
                              if (picked != null) {
                                setState(() {
                                  fromDateFilter = picked;
                                  currentPage = 0;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    fromDateFilter != null
                                        ? DateFormat('MMM dd, yyyy').format(fromDateFilter!)
                                        : "From Date",
                                    style: TextStyle(
                                      color: fromDateFilter != null ? Colors.black : Colors.grey[600],
                                    ),
                                  ),
                                  Icon(Icons.calendar_today, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: toDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2026),
                              );
                              if (picked != null) {
                                setState(() {
                                  toDateFilter = picked;
                                  currentPage = 0;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    toDateFilter != null
                                        ? DateFormat('MMM dd, yyyy').format(toDateFilter!)
                                        : "To Date",
                                    style: TextStyle(
                                      color: toDateFilter != null ? Colors.black : Colors.grey[600],
                                    ),
                                  ),
                                  Icon(Icons.calendar_today, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (fromDateFilter != null || toDateFilter != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: TextButton.icon(
                          icon: Icon(Icons.clear, size: 16),
                          label: Text("Clear dates"),
                          onPressed: () {
                            setState(() {
                              fromDateFilter = null;
                              toDateFilter = null;
                              currentPage = 0;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogDetails(LogEntry log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow("Reference ID", log.refId),
              _buildDetailRow("Item ID", log.itemId),
              _buildDetailRow("QR ID", log.qrId),
              _buildDetailRow("Location", log.locationId),
              _buildDetailRow("Status", log.issuanceStatus),
              _buildDetailRow("Request Number", log.requestNumber),
              _buildDetailRow("From Date", formatDate(log.fromDate)),
              _buildDetailRow("To Date", formatDate(log.toDate)),
              _buildDetailRow("Description", log.description),
              _buildDetailRow("Active Flag", log.activeFlag),
              _buildDetailRow("Created By", log.createdBy),
              _buildDetailRow("Updated On", formatDate(log.updatedOn)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQRCode(LogEntry log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("QR Code"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(
                  "QR Code for:\n${log.qrId}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Item ID: ${log.itemId}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(log.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.print),
            label: Text("Print"),
            onPressed: () {
              // Print functionality would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Printing QR code...")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}

class LogTableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Log System',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.light,
      home: PaginatedLogTable(),
    );
  }
}
