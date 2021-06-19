import 'package:shadertoy/src/model/output.dart';
import 'package:test/test.dart';

void main() {
  var output1 = Output(id: 'id1', channel: 1);
  test('Test a output', () {
    expect(output1.id, 'id1');
    expect(output1.channel, 1);
  });

  test('Convert a output to a JSON serializable map and back', () {
    var json = output1.toJson();
    var output2 = Output.fromJson(json);
    expect(output1, equals(output2));
  });
}
