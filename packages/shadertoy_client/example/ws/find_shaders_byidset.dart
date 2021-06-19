import 'package:shadertoy_client/shadertoy_client.dart';

import '../env.dart';

final Set<String> shaders = {
  'Xds3zN',
  'XslGRr',
  'XsX3RB',
  'MdX3Rr',
  'MdX3zr',
  'ld3Gz2',
  '4ttSWf',
  '4tjGRh',
  '4dfGzs',
  'MsXGWr',
  'XtlSD7',
  'MdlGW7',
  '4lKSzh',
  'Msl3Rr',
  'XdsGDB',
  'lsSXzD',
  'lsl3RH',
  'ldXXDj',
  'ldlcRf',
  'ldl3W8',
  'XdBGzd',
  'Xd23Dh',
  'ldfyzl',
  'MddGzf',
  '4sX3R2',
  '4sfGDB',
  'MdBGzG',
  'llj3Rz',
  '4sS3zG',
  'll2GD3',
  '4sX3Rn',
  'XtsSWs',
  'MdfGRX',
  'llK3Dy',
  '4slGD4',
  'MdjGR1',
  '4dSGW1',
  '4tByz3',
  '4sfGzS',
  'XsfGDn',
  'lsX3W4',
  'Xd23zh',
  'MsXGRf',
  'ldl3zN',
  '4dcGW2',
  'ldj3Dm',
  'XlBSRz',
  'XsfGD4',
  'MsfGzM',
  'lsXGzH',
  '4tdSWr'
};

void main(List<String> arguments) async {
  // If the api key is not specified in the arguments, try the environment one
  var apiKey = arguments.isEmpty ? Env.apiKey : arguments[0];

  // if no api key is found abort
  if (apiKey.isEmpty) {
    print('Invalid API key');
    return;
  }

  var ws = newShadertoyWSClient(apiKey);
  var result = await ws.findShadersByIdSet(shaders);
  print('${result.total} shader(s)');
}
