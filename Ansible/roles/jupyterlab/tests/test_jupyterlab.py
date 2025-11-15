import pytest
import yaml
from pathlib import Path

def load_defaults():
    defaults_path = Path(__file__).resolve().parent.parent / "defaults" / "main.yml"
    with open(defaults_path, "r") as f:
        return yaml.safe_load(f)

def get_var(host, key):
    vars = host.ansible.get_variables()
    if key in vars:
        return vars[key]
    defaults = load_defaults()
    return defaults.get(key)

def test_jupyter_user_exists(host):
    user_name = get_var(host, "jupyterlab_user")
    user = host.user(user_name)
    assert user.exists

def test_bashrc_contains_path_export(host):
    home = get_var(host, "jupyterlab_home")
    if not home:
        pytest.skip("jupyterlab_home not defined")
    bashrc = host.file(f"{home}/.bashrc")
    expected = f'export PATH="{home}/.local/bin:$PATH"'
    assert bashrc.contains(expected)

@pytest.mark.parametrize("binary", [
    "jupyter",
    "jupyter-lab",
    "jupyter-notebook",
    "jupyter-qtconsole"
])
def test_jupyter_binaries_exist(host, binary):
    home = get_var(host, "jupyterlab_home")
    if not home:
        pytest.skip("jupyterlab_home not defined")
    path = f"{home}/.local/share/pipx/venvs/jupyter-core/bin/{binary}"
    file = host.file(path)
    assert file.exists

def test_config_file_exists(host):
    config_path = get_var(host, "jupyterlab_config_path")
    if not config_path:
        pytest.skip("jupyterlab_config_path not defined")
    file = host.file(config_path)
    assert file.exists

def test_config_contains_redirect_setting(host):
    config_path = get_var(host, "jupyterlab_config_path")
    use_redirect = get_var(host, "jupyterlab_use_redirect_file")
    if config_path is None or use_redirect is None:
        pytest.skip("必要な変数が定義されていません")
    expected = f"c.ServerApp.use_redirect_file = {'True' if use_redirect else 'False'}"
    file = host.file(config_path)
    assert file.contains(expected)

def test_config_contains_browser_setting(host):
    config_path = get_var(host, "jupyterlab_config_path")
    if not config_path:
        pytest.skip("jupyterlab_config_path not defined")
    file = host.file(config_path)
    assert file.contains("c.ServerApp.browser =")
