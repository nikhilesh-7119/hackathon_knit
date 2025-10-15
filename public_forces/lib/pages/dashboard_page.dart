import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _costOverrunData = [];
  String? _error;
  
  // Progressive states data
  bool _isLoadingLeast = false;
  bool _isLoadingMost = false;
  List<Map<String, dynamic>> _leastProgressiveData = [];
  List<Map<String, dynamic>> _mostProgressiveData = [];
  String? _errorLeast;
  String? _errorMost;
  

  @override
  void initState() {
    super.initState();
    _loadCostOverrunData();
    _loadProgressiveStatesData();
  }

  Future<void> _loadCostOverrunData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getAnalysisData(
        tableName: 'cost_overrun_top10',
        page: 1,
        pageSize: 10,
      );
      
      // Print complete response to console
      print('=== COST OVERRUN TOP10 API RESPONSE ===');
      print('Complete Response: $response');
      print('Response Type: ${response.runtimeType}');
      print('Response Keys: ${response.keys.toList()}');
      if (response['data'] != null) {
        print('Data Length: ${response['data'].length}');
        print('First Item: ${response['data'].isNotEmpty ? response['data'][0] : 'No data'}');
        print('All Data Items:');
        for (int i = 0; i < response['data'].length; i++) {
          print('Item $i: ${response['data'][i]}');
        }
      }
      print('=====================================');
      
      if (response['data'] != null) {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response['data']);
        setState(() {
          _costOverrunData = data;
        });
      }
    } catch (e) {
      print('=== COST OVERRUN API ERROR ===');
      print('Error: $e');
      print('==============================');
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProgressiveStatesData() async {
    // Load least progressive states
    _loadLeastProgressiveData();
    // Load most progressive states
    _loadMostProgressiveData();
  }

  Future<void> _loadLeastProgressiveData() async {
    setState(() {
      _isLoadingLeast = true;
      _errorLeast = null;
    });

    try {
      final response = await ApiService.getAnalysisData(
        tableName: 'least_progressive_states',
        page: 1,
        pageSize: 10,
      );
      
      print('=== LEAST PROGRESSIVE STATES API RESPONSE ===');
      print('Complete Response: $response');
      if (response['data'] != null) {
        print('Data Length: ${response['data'].length}');
        print('First Item: ${response['data'].isNotEmpty ? response['data'][0] : 'No data'}');
      }
      print('============================================');
      
      if (response['data'] != null) {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response['data']);
        setState(() {
          _leastProgressiveData = data;
        });
      }
    } catch (e) {
      print('=== LEAST PROGRESSIVE API ERROR ===');
      print('Error: $e');
      print('===================================');
      setState(() {
        _errorLeast = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingLeast = false;
      });
    }
  }

  Future<void> _loadMostProgressiveData() async {
    setState(() {
      _isLoadingMost = true;
      _errorMost = null;
    });

    try {
      final response = await ApiService.getAnalysisData(
        tableName: 'most_progressive_states',
        page: 1,
        pageSize: 10,
      );
      
      print('=== MOST PROGRESSIVE STATES API RESPONSE ===');
      print('Complete Response: $response');
      if (response['data'] != null) {
        print('Data Length: ${response['data'].length}');
        print('First Item: ${response['data'].isNotEmpty ? response['data'][0] : 'No data'}');
      }
      print('============================================');
      
      if (response['data'] != null) {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response['data']);
        setState(() {
          _mostProgressiveData = data;
        });
      }
    } catch (e) {
      print('=== MOST PROGRESSIVE API ERROR ===');
      print('Error: $e');
      print('==================================');
      setState(() {
        _errorMost = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingMost = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Cost overrun analysis for top 10 states',
            //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //     color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            //   ),
            // ),
            const SizedBox(height: 32),
            
            // Cost Overrun Chart
            _buildCostOverrunChart(),
            const SizedBox(height: 32),
            
            // Progressive States Charts
            _buildProgressiveStatesCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildCostOverrunChart() {
    if (_isLoading) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading data',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadCostOverrunData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_costOverrunData.isEmpty) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No cost overrun data available',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top 10 States - Cost Escalation Percentage',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'States with highest cost overruns compared to allocated budget',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final stateName = _costOverrunData[group.x.toInt()]['state_name'] ?? 'Unknown';
                      final percentage = rod.toY.toStringAsFixed(1);
                      return BarTooltipItem(
                        '$stateName\n$percentage%',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _costOverrunData.length) {
                          final stateName = _costOverrunData[value.toInt()]['state_name'] ?? 'Unknown';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              stateName.length > 8 ? '${stateName.substring(0, 8)}...' : stateName,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxY() / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _costOverrunData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> item = entry.value;
      
      // Get cost escalation percentage from the correct field name
      double percentage = double.tryParse(item['cost_escalation_pct'].toString()) ?? 0.0;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percentage,
            color: _getBarColor(percentage),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color _getBarColor(double percentage) {
    if (percentage >= 300) {
      return Colors.red.withOpacity(0.8);
    } else if (percentage >= 150) {
      return Colors.orange.withOpacity(0.8);
    } else {
      return Colors.green.withOpacity(0.8);
    }
  }

  double _getMaxY() {
    if (_costOverrunData.isEmpty) return 500;
    
    double maxPercentage = 0;
    for (var item in _costOverrunData) {
      double percentage = double.tryParse(item['cost_escalation_pct'].toString()) ?? 0.0;
      if (percentage > maxPercentage) {
        maxPercentage = percentage;
      }
    }
    
    // Round up to nearest 100 for clean Y-axis (100, 200, 300, 400, 500)
    double result = ((maxPercentage / 100).ceil() * 100).toDouble();
    return result > 0 ? result : 500;
  }

  Widget _buildProgressiveStatesCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State Progress Analysis',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Least and most progressive states based on progress score',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),
        
        // Vertical layout charts
        Column(
          children: [
            // Least Progressive States Chart
            _buildLeastProgressiveChart(),
            const SizedBox(height: 24),
            // Most Progressive States Chart
            _buildMostProgressiveChart(),
          ],
        ),
      ],
    );
  }

  Widget _buildLeastProgressiveChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Least Progressive States',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'States with lowest progress scores',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoadingLeast
                ? const Center(child: CircularProgressIndicator())
                : _errorLeast != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading data',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _leastProgressiveData.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          )
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 50,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipRoundedRadius: 8,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final stateName = _leastProgressiveData[group.x.toInt()]['states'] ?? 'Unknown';
                                    final score = rod.toY.toStringAsFixed(1);
                                    return BarTooltipItem(
                                      '$stateName\nScore: $score',
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 && value.toInt() < _leastProgressiveData.length) {
                                        final stateName = _leastProgressiveData[value.toInt()]['states'] ?? 'Unknown';
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            stateName.length > 8 ? '${stateName.substring(0, 8)}...' : stateName,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _buildLeastProgressiveBarGroups(),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 10,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostProgressiveChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Progressive States',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'States with highest progress scores',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoadingMost
                ? const Center(child: CircularProgressIndicator())
                : _errorMost != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading data',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _mostProgressiveData.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          )
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 50,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipRoundedRadius: 8,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final stateName = _mostProgressiveData[group.x.toInt()]['states'] ?? 'Unknown';
                                    final score = rod.toY.toStringAsFixed(1);
                                    return BarTooltipItem(
                                      '$stateName\nScore: $score',
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 && value.toInt() < _mostProgressiveData.length) {
                                        final stateName = _mostProgressiveData[value.toInt()]['states'] ?? 'Unknown';
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            stateName.length > 8 ? '${stateName.substring(0, 8)}...' : stateName,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _buildMostProgressiveBarGroups(),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 10,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildLeastProgressiveBarGroups() {
    return _leastProgressiveData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> item = entry.value;
      
      double score = double.tryParse(item['progress_score'].toString()) ?? 0.0;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: score,
            color: Colors.red.withOpacity(0.8),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildMostProgressiveBarGroups() {
    return _mostProgressiveData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> item = entry.value;
      
      double score = double.tryParse(item['progress_score'].toString()) ?? 0.0;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: score,
            color: Colors.green.withOpacity(0.8),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

}