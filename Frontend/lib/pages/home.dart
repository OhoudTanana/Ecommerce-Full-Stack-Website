import 'package:ecommerce/pages/customers.dart';
import 'package:ecommerce/pages/invoices.dart';
import 'package:ecommerce/pages/items.dart';
import 'package:ecommerce/widgets/head_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //we build the UI here, returns a widget tree that represents the page layout
  //BuildContext represents the location of widget in a widget tree, we use it to access info about
  //position and to interact with parents and children
  //buildContext is like the address of this widget in a larger widget tree
  //represnt the location of HomePage widget within th overall widget tree of the app
  //all here share the same context, allows child widget to interact with parent homePage widget and surrounding widget tree
  @override
  @override
  Widget build(BuildContext context) {
    //Scaffold widget contains the basic structure of a page, appBar, body ..
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeadBar(title: "Admin Panel", showLeading: false),
      body: Padding(
        //a widget that adds space around child widget and its surrounding elements or the conatiner
        padding: const EdgeInsets.all(
            16.0), //same padding value applied to all 4 sides of a child widget
        child: Column(
          //here the padding is added around the column widget
          //column is a layout widget that arranges its child widgets in vertical line, her row is child of column
          mainAxisAlignment: MainAxisAlignment
              .center, //centers the Row widget vertically within the availabe space
          children: [
            Row(
              //aranges its children horixantally
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, //ensuring equal space btw elemnts in a row
              children: [
                //custom buttons
                customButton(context, "Customers", Icons.manage_accounts,
                    const CustomersPage()),
                customButton(
                    context, "Items", Icons.category, const ItemsPage()),
                customButton(
                    context, "Invoices", Icons.receipt, const InvoicesPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

//dynamic, helps us to navigate to pages based on the given info, it returns a widget
//BuildContext here is used to interact with the widget tree, navigation
  Widget customButton(
      BuildContext context, String title, IconData icon, Widget page) {
    //sizedBox a widget that defines a fixed width and heigth
    return SizedBox(
      width: 250,
      height: 250,
      //a button, when pressed triggers an action, used for primary actions(due to its style)
      child: ElevatedButton(
        //callback funtion excuted when we press the button
        onPressed: () {
          //called when we want to navigate to new page
          Navigator.push(
            context, //required by navigator to know where is the widget tree(where we are currently to go from there)
            //creates a new route to be pushed in stack
            MaterialPageRoute(
                builder: (context) =>
                    page), /*tells flutter to build this pay(to be displayed)*/
          );
        },

        //styling the button
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 241, 177, 199),
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        //button content
        child: Column(
          //organized vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //icon
            Icon(icon, color: Colors.white, size: 50),
            //adds a small space between text and icon
            const SizedBox(height: 8),
            //text
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
