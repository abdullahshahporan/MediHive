import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final List<Map<String, String>> contacts = [
    {"title": "National Emergency Service", "number": "999"},
    {"title": "Fire Service", "number": "16163"},
    {"title": "Square Hospital", "number": "10616"},
    {"title": "Popular Diagnostic Centre", "number": "10636"},
    {"title": "LABAID Diagnostic", "number": "10606"},
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _showContactDialog(BuildContext context, String title, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.call, color: Colors.white, size: 30),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _makePhoneCall(number);
                },
                icon: Icon(Icons.call, color: Colors.white),
                label: Text("Call Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergency Contacts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  contact['title']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contact['number']!,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                onTap: () => _showContactDialog(
                  context,
                  contact['title']!,
                  contact['number']!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




/*class EmergencyContactScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {"title": "John Doe", "number": "1234567890"},
    {"title": "Jane Smith", "number": "9876543210"},
    {"title": "Alice Johnson", "number": "5556667777"},
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _showContactDialog(BuildContext context, String title, String number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.call, color: Colors.white, size: 30),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _makePhoneCall(number);
                },
                icon: Icon(Icons.call, color: Colors.white),
                label: Text("Call Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergency Contacts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  contact['title']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contact['number']!,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                onTap: () => _showContactDialog(
                  context,
                  contact['title']!,
                  contact['number']!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}*/
