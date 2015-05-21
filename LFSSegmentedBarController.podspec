Pod::Spec.new do |s|
	s.name         = "LFSSegmentedBarController"
	s.version      = "1.0.8"
	s.summary      = "iOS implementation of Android Tab Bar"
	s.homepage     = "https://github.com/lafosca/LFSSegmentedBarController"

	s.author       = { "David Cortés" => "david@lafosca.cat" }
	s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
	s.source       = {
		:git => "https://github.com/lafosca/LFSSegmentedBarController.git",
		:tag => "1.0.8"
	}

	s.ios.deployment_target = '7.0'
	s.source_files = 'lib/*.{h,m}'
	s.requires_arc = true
end
