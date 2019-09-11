# blender_gnu_parallel_render

Use GNU Parallel to render blender movies distributed by a bunch of nodes

All nodes must have blender installed and be reachable using SSH with SSH keys and be listed at ~/.parallel/sshloginfile file, like this example:

    1\ user@192.168.0.101
    1\ user@192.168.0.102
    1\ user@192.168.0.103
    1\ user@192.168.0.104

Just call this way:

    render_blender_parallel.sh blender_file_name.blender start_frame end_frame ext

Where:

- `blender_file_name` is the blender file to be rendered.
- `start_frame` is the number of first frame to be rendered.
- `end_frame` is the number of the last frame to be rendered.
- `ext` the extension of the output frames (ex. png, jpeg, etc.).

The result is a folder containing the output frames. The folder will have the same name of `blender_file_name` parent folder plug `-frames`.
