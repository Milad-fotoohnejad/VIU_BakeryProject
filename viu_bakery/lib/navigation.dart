import 'package:flutter/material.dart';
import 'package:viu_bakery/search_page.dart';
import 'login_signup_page.dart';
import 'recipe_upload_page.dart';
import 'my_account_page.dart';

class TopNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[300],
      child: Column(
        children: [
          Container(
            height: 56,
            margin: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    '../background-assets/viu_logo.png',
                    height: 72,
                    width: 72,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNavItem(title: 'Home', onTap: () {}),
                _buildNavItem(
                    title: 'Search Recipe',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    }),
                _buildNavItem(
                    title: 'Sign In',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginSignupPage()),
                      );
                    }),
                _buildNavItem(
                  title: 'My Account',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAccountPage()),
                    );
                  },
                ),
                _buildNavItem(
                    title: 'Upload Recipe Excel',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeUploadPage()),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required String title, required VoidCallback onTap}) {
    final ValueNotifier<bool> _hoverNotifier = ValueNotifier(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _hoverNotifier,
            builder: (context, isHovering, child) {
              return Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isHovering ? Colors.blue[800] : Colors.white,
                ),
              );
            },
          ),
        ),
        onHover: (isHovering) {
          _hoverNotifier.value = isHovering;
        },
      ),
    );
  }
}
