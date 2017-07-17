
Pod::Spec.new do |s|
  s.name             = 'LoggerWrapper'
  s.version          = '0.2'
  s.summary          = 'A very simple library that aims to provide a simple wrapper around the various logging library that exists for iOS.'

  s.description      = <<-DESC
		A very simple library that aims to provide a simple wrapper around the various logging library that exists for iOS.
		Currently supports CocoaLumberjack, and can optionally integrate with PluggableApplicationDelegate.

    Ideally, this library allows library creators to allow to use logging, without relying on the classic NSLog/print which
    can't be disabled easily.
                       DESC

  s.homepage         = 'https://github.com/stephanecopin/LoggerWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stephanecopin' => 'stephane.copin@live.fr' }
  s.source           = { :git => 'https://github.com/stephanecopin/LoggerWrapper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://fueled.com/stephane'

  s.ios.deployment_target = '9.0'

	s.default_subspec = 'ObjC'
 
	s.subspec 'ObjC' do |cs|
		cs.source_files = 'LoggerWrapper/Classes/*.{h,m}'
	end

	s.subspec 'Swift' do |cs|
		cs.dependency 'LoggerWrapper/ObjC'
		cs.source_files = 'LoggerWrapper/Classes/*.{swift}'
	end

	s.subspec 'CocoaLumberjack' do |cs|
		cs.subspec 'Core' do |css|
			css.dependency 'LoggerWrapper/ObjC'
			css.dependency 'CocoaLumberjack'
			css.source_files = 'LoggerWrapper/Classes/CocoaLumberjack/*.{h,m,swift}'
		end

		cs.subspec 'Swift' do |css|
			css.dependency 'LoggerWrapper/Swift'
			css.dependency 'CocoaLumberjack/Swift'
			css.source_files = 'LoggerWrapper/Classes/CocoaLumberjack/*.{h,m,swift}'
		end

		cs.subspec 'PluggableApplicationDelegate' do |css|
			css.dependency 'LoggerWrapper/CocoaLumberjack/Swift'
			css.dependency 'PluggableApplicationDelegate'
			css.source_files = 'LoggerWrapper/Classes/CocoaLumberjack/PluggableApplicationDelegate/**/*'
		end
	end
end
