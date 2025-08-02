import 'package:flutter/material.dart';

class FilterPopup extends StatelessWidget {
  final List<String> provinces = [
    'Central',
    'Sabaragamuwa',
    'Western',
    'Southern',
    'North Western',
    'Eastern'
  ];
  final List<int> ratings = [5, 4, 3, 2, 1];
  final List<String> deliveryOptions = ['Choice', 'Free Delivery'];
  final List<String> conditions = ['Brand New', 'Used', 'Recondition'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Wrap(
        runSpacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          _sectionTitle("Shipped From"),
          Wrap(
            spacing: 10,
            children: provinces
                .map((region) => FilterChip(
                      label: Text(region),
                      selected: false,
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          _sectionTitle("Shipped From (Price Range)"),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Min',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Max',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _sectionTitle("Rating"),
          Wrap(
            spacing: 10,
            children: ratings
                .map((star) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$star'),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                        ],
                      ),
                      selected: false,
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          _sectionTitle("Delivery Option & Services"),
          Wrap(
            spacing: 10,
            children: deliveryOptions
                .map((opt) => FilterChip(
                      label: Text(opt),
                      selected: false,
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          _sectionTitle("Condition"),
          Wrap(
            spacing: 10,
            children: conditions
                .map((cond) => FilterChip(
                      label: Text(cond),
                      selected: false,
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text("Apply Filters"),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16));
  }
}
