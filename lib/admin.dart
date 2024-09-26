import 'package:flutter/material.dart';
/*
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}
*/

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/your-background-image-dashboard.jpg'), // Replace 'assets/your-background-image-dashboard.jpg' with your actual image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      children: [
                        DashboardButton(
                            title: 'Category Management',
                            link: 'categorymanagement.htm'),
                        DashboardButton(
                            title: 'Product Management', link: 'product.htm'),
                        DashboardButton(
                            title: 'Search Product', link: 'searchproduct.htm'),
                        DashboardButton(
                            title: 'Company Management', link: 'company.htm'),
                        DashboardButton(
                            title: 'Generate Reports', link: 'report.htm'),
                        DashboardButton(
                            title: 'Access Invoices', link: 'invoice.htm'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String title;
  final String link;

  const DashboardButton({required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
// Add navigation logic here
        },
        child: Text(title),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
      ),
    );
  }
}
