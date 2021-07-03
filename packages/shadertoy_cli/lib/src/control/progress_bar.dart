import 'dart:io';
import 'dart:math';

/// ProgressBar
class ProgressBar {
  final String format;
  final int total;
  final String completeChar;
  final String incompleteChar;
  final Function? callback;

  int width = 0;
  bool clear = false;
  int curr = 0;
  DateTime start = DateTime.now();
  String lastDraw = '';
  bool complete = false;

  ///
  /// Initialize a `ProgressBar` with the given `format` string and the `options` map.
  /// Format tokens:
  ///
  ///   - `:bar` the progress bar itself
  ///   - `:current` current tick number
  ///   - `:total` total ticks
  ///   - `:elapsed` time elapsed in seconds
  ///   - `:percent` completion percentage
  ///   - `:eta` eta in seconds
  ///
  /// Options:
  ///
  ///   - `total` total number of ticks to complete
  ///   - `width` the displayed width of the progress bar defaulting to total
  ///   - `complete` completion character defaulting to "="
  ///   - `incomplete` incomplete character defaulting to "-"
  ///   - `callback` optional function to call when the progress bar completes
  ///
  ProgressBar(this.format,
      {this.total = 0,
      this.completeChar = '=',
      this.incompleteChar = '-',
      this.callback,
      int? width})
      : width = width ?? total;

  ///
  /// "tick" the progress bar with optional `len` and optional `tokens`.
  ///
  void tick({int len = 1, Map<String, String>? tokens}) {
    if (curr == 0) {
      start = DateTime.now();
    }

    curr += len;
    render(tokens);

    // progress complete
    if (curr >= total) {
      complete = true;
      terminate();
      final cb = callback;
      if (cb != null) {
        Function.apply(cb, [complete]);
      }
    }
  }

  ///
  /// Method to render the progress bar with optional `tokens` to place in the
  /// progress bar's `format` field.
  ///
  void render(Map<String, String>? tokens) {
    if (!stdout.hasTerminal) return;

    final ratio = min(max(curr / total, 0.0), 1.0);

    final percent = ratio * 100;
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    final eta = (percent == 100) ? 0 : elapsed * (total / curr - 1);

    /* populate the bar template with percentages and timestamps */
    var str = format
        .replaceAll(':current', curr.toString())
        .replaceAll(':total', total.toString())
        .replaceAll(':elapsed',
            elapsed.isNaN ? '0.0' : (elapsed / 1000).toStringAsFixed(1))
        .replaceAll(
            ':eta',
            (eta.isNaN || !eta.isFinite)
                ? '0.0'
                : (eta / 1000).toStringAsFixed(1))
        .replaceAll(':percent', percent.toStringAsFixed(0) + '%');

    /* compute the available space (non-zero) for the bar */
    final availableSpace =
        max(0, stdout.terminalColumns - str.replaceAll(':bar', '').length);
    final width = min(this.width, availableSpace);

    /* the following assumes the user has one ':bar' token */
    final completeLength = (width * ratio).round();
    final complete = List<String>.filled(completeLength, completeChar).join();
    final incomplete =
        List<String>.filled(width - completeLength, incompleteChar).join();

    /* fill in the actual progress bar */
    str = str.replaceAll(':bar', complete + incomplete);

    /* replace the extra tokens */
    if (tokens != null) {
      tokens.forEach((key, val) {
        str = str.replaceAll(':' + key, val);
      });
    }

    if (lastDraw != str) {
      stdout.writeCharCode(13); // output carriage return
      stdout.write(str);
      lastDraw = str;
    }
  }

  ///
  /// "update" the progress bar to represent an exact percentage.
  /// The ratio (between 0 and 1) specified will be multiplied by `total` and
  /// floored, representing the closest available "tick." For example, if a
  /// progress bar has a length of 3 and `update(0.5)` is called, the progress
  /// will be set to 1.
  ///
  /// A ratio of 0.5 will attempt to set the progress to halfway.
  ///
  void update(num ratio) {
    final goal = (ratio * total).floor();
    final delta = goal - curr;
    tick(len: delta);
  }

  ///
  /// Terminates a progress bar.
  ///
  void terminate() {
    stdout.writeln();
  }
}
