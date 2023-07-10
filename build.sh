#this script should be executed directly from the build directory.
#!/bin/bash

# Define default values
install_path=""
build_path=""

# Get the directory of the script
script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")


echo "Script directory: $script_dir"

# Function to display script usage
display_usage() {
    echo "Usage: $0 --BUILDPATH <absolute path> --INSTALLPATH <absolute path>"
    echo "Mandatory arguments:"
    echo "  --BUILDPATH <path>    Specify the buld path"
    echo "  --INSTALLPATH <path>    Specify the install path"
    exit 1
}

# Function to check if a directory exists
directory_exists() {
    if [ -d "$1" ]; then
        return 0  # Directory exists
    else
        return 1  # Directory does not exist
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    echo "key '$key'"
    case $key in
        --INSTALLPATH)
            install_path="$2"
            echo "install_path='$2' "
            shift
            ;;
        --BUILDPATH)
            build_path="$2"
            echo "build_path='$2' "
            shift
            ;;
        *)
            # Unknown option
            display_usage
            ;;
    esac
    shift
done

# Check if mandatory arguments are provided
if [ -z "$install_path" ] || [ -z "$build_path" ]; then
    echo "Missing mandatory arguments"
    display_usage
fi

# Check if install_path exists
if ! directory_exists "$install_path"; then
    echo "Install path '$install_path' does not exist."
    exit 1
fi

# Check if build_path exists
if ! directory_exists "$build_path"; then
    echo "Build path '$build_path' does not exist."
    exit 1
fi

# Continue with the script using the provided install path and build path
echo "Install path: $install_path"
echo "Build path: $build_path"

echo "Calling cmake"
#cp $script_dir/CMakeCache.txt $build_path
cd $build_path
cmake $script_dir -DCMAKE_INSTALL_PREFIX=$install_path
echo "Calling cmake build"
cmake --build . -j8
make install
