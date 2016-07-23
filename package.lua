name = 'cool-test-project'
lua = '5.3.2'
dependencies = {
  'lua == 5.3',
  'chain == 1.0-1'
}
dev_dependencies = {
  'mach >= 4.4-1',
  'busted >= 2.0.rc11-0'
}
scripts = {
  test = 'busted',
  demo = [[lua -e "require 'src.test'(print)"]]
}
