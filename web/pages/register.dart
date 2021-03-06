// Copyright (c) 2015, Gérald Reinhart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library connecting_dartisans.pages.register;

import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:gex_webapp_kit/webapp_kit_client.dart';
import 'package:gex_webapp_kit/webapp_kit_common.dart';
import 'package:gex_webapp_kit/client/elements/layout.dart';
import 'package:gex_webapp_kit/client/elements/user_edit.dart';
import 'package:gex_webapp_kit/client/elements/page.dart';
import 'package:connecting_dartisans/connecting_dartisans_client.dart';

@CustomTag('page-register')
class PageRegister extends Page with Showable {
  static final String NAME = "register";
  final Logger log = new Logger('PageRegister');

  Color mainColor = Color.WHITE;

  Layout layout;
  UserEdit userEdit;

  PageRegister.created() : super.created();

  ready() {
    super.ready();
    _setAttributes();
  }

  @override
  void show() {
    super.show();
    userEdit.show();
  }

  @override
  void hide() {
    super.hide();
    userEdit.hide();
  }

  void _setAttributes() {
    layout = $["layout"] as Layout;
    userEdit = $["userEdit"] as UserEdit;

    List<ButtonModel> buttonModels = new List<ButtonModel>();
    buttonModels.add(new ButtonModel(
        label: "Register", action: register, image: new Image(mainImageUrl: "/images/button/create1.png")));
    buttonModels.add(
        new ButtonModel(label: "Cancel", action: cancel, image: new Image(mainImageUrl: "/images/button/back57.png")));

    ToolbarModel toolbarModel = new ToolbarModel(
        buttons: buttonModels,
        color: Color.GREY_858585.lightColorAsColor,
        colorUsage: ColorUsage.ALTERNATE_WITH_LIGHT,
        orientation: Orientation.est);

    LayoutModel layoutModel = new LayoutModel(toolbarModel: toolbarModel, color: mainColor);
    PageModel model = new PageModel(name: NAME, layoutModel: layoutModel);
    this.init(model);
  }

  @override
  void recieveApplicationEvent(ApplicationEvent event) {
    super.recieveApplicationEvent(event);
    if (event.isUserAuthSuccess) {
      userEdit.user = event.user;
      userEdit.map.geoLocation();
    }
    if (event is DartisansApplicationEvent) {
      if (this.isShowed() && event.isSaveDartisanSuccess) {
        toastMessage("Profile saved", color: Color.BLUE_0082C8);
      }
    }
  }

  void register(Parameters params) {
    fireApplicationEvent(new ApplicationEvent.callRegister(this, userEdit.user));
  }
  cancel(Parameters params) {
    fireApplicationEvent(new ApplicationEvent.callIndexPage(this));
  }
}
