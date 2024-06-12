/// A base abstract class for all Hooks.
/// Hooks are reusable logic that can be shared across different parts
/// of the application, encapsulating initialization and disposal logic.
abstract class Hook<R> {
  /// A function to trigger a rebuild of the widget tree.
  late final void Function() setState;

  /// Called when the Hook is initialized.
  void init();

  /// Called when the Hook is disposed.
  void dispose();
}
