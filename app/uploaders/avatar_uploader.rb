# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
     %w(jpg jpeg png gif)
  end

  process :store_dimensions
  process :resize_to_limit => [500, 500]

  version :thumb do
    process :crop
    process :resize_to_fill => [130, 130]
  end

  version :mini do
    process :crop
    process :resize_to_fill => [75, 75]
  end

  private
    def crop
      if model.crop_x.present?
        ratio = model.original_width/image_width
        manipulate! do |img|
          x = (model.crop_x.to_i/ratio).to_i
          y = (model.crop_y.to_i/ratio).to_i
          w = (model.crop_w.to_i/ratio).to_i
          h = (model.crop_h.to_i/ratio).to_i

          img.crop!(x,y,w,h)
        end
      end
    end

    def store_dimensions
      if !model.original_width.present?
        model.original_width = image_width.to_f
        model.original_height = image_height.to_f
      end
    end

    def image
      img ||= ::Magick::Image::read(file.file).first
    end

    def image_width
      image.columns
    end

    def image_height
      image.rows
    end

  #convert the base64
  #class FilelessIO < StringIO
  #  attr_accessor :original_filename
  #  attr_accessor :content_type
  #end

  #before :cache, :convert_base64

  #def convert_base64(file)
  #  if file.respond_to?(:original_filename) &&
  #      file.original_filename.match(/^base64:/)
  #    fname = file.original_filename.gsub(/^base64:/, '')
  #    ctype = file.content_type
  #    decoded = Base64.decode64(file.read)
  #    file.file.tempfile.close!
  #    decoded = FilelessIO.new(decoded)
  #    decoded.original_filename = fname
  #    decoded.content_type = ctype
  #    file.__send__ :file=, decoded
  #  end
  #  file
  #end
  #end of convert base64

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [1200, 1200]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
