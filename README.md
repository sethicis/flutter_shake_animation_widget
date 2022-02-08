# flutter_shake_animation_widget
Flutter Shake Animation Component


#### Jitter effect

````
  /// Build the jitter effect
  ShakeAnimationWidget buildShakeAnimationWidget() {
    return ShakeAnimationWidget(
      //jitter controller
      shakeAnimationController: _shakeAnimationController,
      // micro-rotation jitter
      shakeAnimationType: ShakeAnimationType.SkewShake,
      //Set to not turn on jitter
      isForward: false,
      //The default is 0 for infinite execution
      shakeCount: 0,
      //The amplitude of the jitter ranges from [0,1]
      shakeRange: 0.2,
      //The child Widget that performs the shaking animation
      child: RaisedButton(
        child: Text(
          'test',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          ///Determine whether the shaking animation is executing
          if (_shakeAnimationController.animationRunging) {
            ///Stop the jitter animation
            _shakeAnimationController.stop();
          } else {
            ///Enable the shaking animation
            ///The parameter shakeCount is used to configure the number of shakes
            ///The default is 1 by the controller start method
            _shakeAnimationController.start(shakeCount: 1);
          }
        },
      ),
    );
  }
````

#### Custom bottom menu

````
      BottomRoundFlowMenu(
          //The background used by the icon
          defaultBackgroundColor: Colors.white,
          //All icons of the menu
          iconList: iconList,
          //Corresponding to the menu item click event callback
          clickCallBack: (int index) {
            //print("Clicked on $index");
          },
        )
````

#### Animated buttons

````
  //The controller used by the animation button
  AnimatedStatusController animatedStatusController =
  new AnimatedStatusController();

  // toggle style animation button
  Widget buildAnimatedStatusButton() {
    return AnimatedStatusButton(
      //controller
      animatedStatusController: animatedStatusController,
      //display the width of the button
      width: 220.0,
      //display the height of the button
      height: 40,
      // animation interaction time
      milliseconds: 1000,
      buttonText: 'Submit',
      //background color
      backgroundNormalColor: Colors.white,
      // border color
      borderNormalColor: Colors.deepOrange,
      //text color
      textNormalCcolor: Colors.deepOrange,
      //click callback
      clickCallback: () async {
        //print("Click event callback");
        //Simulate time-consuming operation
        await Future.delayed(Duration(milliseconds: 4000));

        //Returning false will keep going in circles
        //Returning true will return to the default display style
        return Future.value(false);
      },
    );
  }

````


#### Vertical popup menu

````
    RoteFlowButtonMenu(
          //The background used by the icon
          defaultBackgroundColor: Colors.deepOrangeAccent,
          //All icons of the menu
          iconList: iconList,
          //Corresponding to the menu item click event callback
          clickCallBack: (int index) {
            //print("Clicked on $index");
          },
        )
````
