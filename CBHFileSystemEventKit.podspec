Pod::Spec.new do |spec|

  spec.name                   = 'CBHFileSystemEventKit'
  spec.version                = '1.0.0'
  spec.module_name            = 'CBHFileSystemEventKit'

  spec.summary                = 'An easier way to watch for file system events.'
  spec.homepage               = 'https://github.com/chris-huxtable/CBHFileSystemEventKit'

  spec.license                = { :type => 'ISC', :file => 'LICENSE' }

  spec.author                 = { 'Chris Huxtable' => 'chris@huxtable.ca' }
  spec.social_media_url       = 'https://twitter.com/@Chris_Huxtable'

  spec.osx.deployment_target  = '10.11'

  spec.source                 = { :git => 'https://github.com/chris-huxtable/CBHFileSystemEventKit.git', :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHFileSystemEventKit/*.h'
  spec.private_header_files   = 'CBHFileSystemEventKit/**/_*.h'
  spec.source_files           = 'CBHFileSystemEventKit/*.{h,m}'

end
