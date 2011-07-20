include BeValidAsset

BeValidAsset::Configuration.display_invalid_content = true
BeValidAsset::Configuration.enable_caching = true
BeValidAsset::Configuration.cache_path = File.join(Rails.root, %w(tmp be_valid_asset_cache))
