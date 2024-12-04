import 'package:ecommerce/pages/home.dart';
import 'package:flutter/material.dart';

//common for all pages
//also doesnt need to keep any state
//PreffredSizeWidget  is used to specify the preffered size of a widget that has a fized height like AppBar
//to ensure that elements inside has a consistent height
//to prevent layout issues
class HeadBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //title dispalyed at the top center
  final Widget?
      action; //to add search property on the right top if needed, this is an action, or any other action
  final bool
      showLeading; //for arrows or drawer list on top left (to navigate back or in)
  final VoidCallback?
      onLeadingPressed; //(when we press on leading if it was found)
  //VoidCallBack takes no arguments and returns no values , used for functions that are called in reponse to action or event
  //here it is used when we press on the home icon for example

//key is used to preserve the state of widgets across rebuild
  const HeadBar(
      {super.key,
      required this.title,
      this.action,
      this.showLeading = true,
      this.onLeadingPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 241, 177, 199),

      title: Align(
        //style
        alignment: Alignment.topCenter,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //if those are not set then flutter will show whatever it wants based on stacks in route
      automaticallyImplyLeading:
          showLeading, //to not let flutter show leading automatically
      //we cant use if else inside widgets so we use conditional logic
      leading:
          showLeading //if true this tells us what we should put in leading place
              ? IconButton(
                  //if true the code after ? is shown , a home icon that navigates to home page
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: onLeadingPressed ??
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                )
              : null, //if showLeading is false then leading is set to null , no widget will appear in the leading position on AppBar

      //actions is property that used to define widgets that appear on the right side of AppBar
      //represents a search icon
      // != null checks if the search icon is not null ? then it will be included in list of actions
      // ! after search is to tell that search is not null
      //: if null, the action property is set to null
      actions: action != null ? [action!] : null,
    );
  }

  //so flutter can know how much space to allocate for the widget

//here flutter will know the height of appBar
//Size class in flutter is used ot define dimnesions
//Size.fromHeight, constructor that specifies the height, and the width is set to default(will take as much horizantal space as possible)
//kToolbarHeight , constant specified by flutter that respesents the default height of AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

//in AppBar leading are always on top left, actions always on top right and we centered text in center
//leadings are typically used for widgets that are navigation related , drawers or backbuttons
//actions commonly used for icons like search, settings or notifications.. 
