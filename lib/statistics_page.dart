import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _streamKey = 0;

  String _getShortenedLabel(String label) {
    const int maxLength = 10;
    if (label.length > maxLength) {
      return '${label.substring(0, maxLength - 2)}...';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      key: ValueKey(_streamKey),
      stream: FirebaseFirestore.instance.collection('classifications').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No classification data found.\nClassify some images to see statistics!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        Map<String, int> classificationCounts = {};
        for (var doc in snapshot.data!.docs) {
          final label = doc['label'] as String;
          final formattedLabel = label.replaceAll('_', ' ');
          classificationCounts[formattedLabel] = (classificationCounts[formattedLabel] ?? 0) + 1;
        }

        final sortedItems = classificationCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        final totalPredictions = snapshot.data!.docs.length;
        final mostFrequent = sortedItems.isNotEmpty ? sortedItems.first.key : 'N/A';
        final uniqueClasses = classificationCounts.keys.length;

        return SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSummaryCard('Total Predictions', totalPredictions.toString(), Icons.functions_rounded),
                    const SizedBox(width: 8),
                    _buildSummaryCard('Most Frequent', mostFrequent, Icons.star_rounded),
                    const SizedBox(width: 8),
                    _buildSummaryCard('Unique Classes', uniqueClasses.toString(), Icons.category_rounded),
                  ],
                ),
                const SizedBox(height: 32),

                const Text(
                  'Prediction Frequency by Class',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shows how often each ball class was predicted',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    // Restoring the full, correct chart data
                    LineChartData(
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          getDrawingHorizontalLine: (value) => const FlLine(color: Colors.black12, strokeWidth: 1),
                          getDrawingVerticalLine: (value) => const FlLine(color: Colors.black12, strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 42,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final index = value.toInt();
                              if (index < classificationCounts.keys.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  angle: -0.7,
                                  child: Text(
                                    _getShortenedLabel(classificationCounts.keys.elementAt(index)),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value > 0 && value % 1 == 0) {
                                return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                              }
                              return const Text('');
                            },
                            reservedSize: 28,
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
                      minX: 0,
                      maxX: (classificationCounts.length - 1).toDouble(),
                      minY: 0,
                      maxY: (classificationCounts.values.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(classificationCounts.length, (index) {
                            final entry = classificationCounts.entries.elementAt(index);
                            return FlSpot(index.toDouble(), entry.value.toDouble());
                          }),
                          isCurved: true,
                          color: Colors.teal,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.teal.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Frequency Ranking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = sortedItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(item.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        trailing: Text(
                          '${item.value} predictions',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.teal),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 4),
              Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
