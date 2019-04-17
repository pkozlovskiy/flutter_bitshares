class NavigateAction {
  final routeName;

  NavigateAction(this.routeName);
}

class NavigateReplaceAction extends NavigateAction {
  NavigateReplaceAction(routeName) : super(routeName);
}

class NavigatePushAction extends NavigateAction {
  NavigatePushAction(routeName) : super(routeName);
}

class NavigatePopAction extends NavigateAction {
  NavigatePopAction() : super(null);
}
