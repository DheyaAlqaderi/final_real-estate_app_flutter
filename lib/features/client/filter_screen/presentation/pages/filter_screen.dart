import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../../core/utils/styles.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Locales.string(context, "filter"), style: fontLargeBold),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(Locales.string(context, "reset")),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Property type section
            Text('نوع الملكية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            const Row(
              children: [
                ChoiceChip(
                  label: Text('فيلا'),
                  selected: false,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('شقة'),
                  selected: true,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('دبلكس'),
                  selected: false,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('أخرى'),
                  selected: false,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Location section
            Text(
              'الموقع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'جدة',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 150,
              color: Colors.grey[300],
              child: Center(child: Text('اختر على الخريطة')),
            ),
            SizedBox(height: 16),

            // Bedrooms section
            Text(
              'غرف نوم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: Text('استوديو'),
                  selected: false,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('1 غرفة نوم'),
                  selected: false,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('2 غرفة نوم'),
                  selected: false,
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('3 غرفة نوم'),
                  selected: true,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Price range section
            Text(
              'أسعار العقار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(125000, 250000),
              min: 0,
              max: 500000,
              divisions: 100,
              labels: RangeLabels('125,000', '250,000'),
              onChanged: (values) {},
            ),
            SizedBox(height: 16),

            // Apply filter button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('تطبيق الفلتر'),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
