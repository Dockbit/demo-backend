# Will first try and copy the file:
#
# config/deploy/#{full_app_name}/#{from}.erb to
# shared/config/to
#
# If the original source path doesn exist then it will search in:
# config/deploy/shared/#{from}.erb
#
# This allows files which are common to all enviros to come from a
# single source while allowing specific ones to be overridden.
#
# If the target file name is the same as the source then
# the second parameter can be left out.
#
def smart_template(from, to = nil)
  to ||= from
  full_to_path = "#{shared_path}/config/#{to}"
  if from_erb_path = template_file(from)
    from_erb = StringIO.new(ERB.new(File.read(from_erb_path)).result(binding))
    upload! from_erb, full_to_path
  else
    error "Error: #{from} not found"
  end
end

def template_file(name)
  if File.exist?((file = "config/deploy/#{fetch(:stage)}/#{name}.erb"))
    return file
  elsif File.exist?((file = "config/deploy/shared/#{name}.erb"))
    return file
  end
  return nil
end
