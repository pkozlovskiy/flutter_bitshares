
enum AppTab { account, market, test }

class UpdateHomeTabAction {
  final AppTab newTab;

  UpdateHomeTabAction(this.newTab);
}
