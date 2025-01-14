# **Cocotb installation**

<div style="background-color: white; display: inline-block; padding: 10px;">
    <img src="https://www.cocotb.org/assets/img/cocotb-logo.svg" alt="Image with Background" />
</div>
<br><br>

### Steps to install Cocotb in windows
1. Make a `.bat` file can be called as `cocotb_install.sh`. Then copy and paste the code from `cocotb_install.bat` from the git repo.
2. Double click it and give administrative previlages, wait for the script to do its work.
3. A foler path will be opened in windows file explorer with a sample `Counter` program in the folder called `sample` folder, right click in the middle of the explorer and select `git bash`, then enter the commands below

```bash
source .venv/Scripts/activate # to activate the python virtual environment
cd sample/Counter # sample program folder
make # Build the project
gtkwave out.vcd # To show the waveform
```

#### **Note
You need to execute the `source .venv/Scripts/activate` everytime when the **git bash** is relaunched

