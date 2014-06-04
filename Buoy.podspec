Pod::Spec.new do |s|
  s.name         = 'Buoy'
  s.version      = '0.0.10'
  s.summary      = 'An iBeacon Listener/Manager class to make your life simpler, matey.'
  s.author = {
    'Ben Gordon' => 'brgordon@ua.edu'
  }
  s.source = {
    :git => 'https://github.com/intermark/Buoy.git',
    :tag => s.version
  }
  s.homepage    = 'https://github.com/intermark'
  s.license     = 'LICENSE.md'
  s.source_files = 'Buoy/ObjC/*.{h,m}'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.framework    = 'CoreBluetooth'
  s.framework    = 'CoreLocation'
end