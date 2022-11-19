import logging
import argparse
import sys

def main():
    # Arguments
    parser = argparse.ArgumentParser(description="Ensures that specified Kernel options are in the system Kernel options file")
    parser.add_argument(
        "--options-file",
        help="Path to file where Kernel options are stored",
        type=str,
        required=True,
    )
    parser.add_argument(
        "--option-name",
        help="Name of Kernel option to set",
        type=str,
        required=True,
    )
    parser.add_argument(
        "--option-value",
        help="Value to set for Kernel option",
        type=str,
        required=True,
    )
    parser.add_argument(
        "--check",
        help="If provided then the script will exit with 0 if the option and value exist, or 1 if they do not, however no changes are written to the Kernel options file",
        action='store_true',
        default=False,
    )

    args = parser.parse_args()

    # Read Kernel options file
    kernel_opts = {}
    read_in = ""
    with open(args.options_file, 'r') as kernel_opts_f:
        read_in = kernel_opts_f.readline()
        opt_pairs = read_in.split(" ")

        for opt_pair in opt_pairs:
            parts = opt_pair.split("=")

            kernel_opts[parts[0]] = "=".join(parts[1:])

    # Ensure Kernel option is set
    write_kernel_opts = { **kernel_opts }

    if (args.option_name in kernel_opts and write_kernel_opts[args.option_name] != args.option_value) or args.option_name not in kernel_opts:
        write_kernel_opts[args.option_name] = args.option_value
        logging.info("Kernel options file does not include correct value")

    # Write changes
    opt_pairs = []
    for opt_name in write_kernel_opts:
        opt_value = write_kernel_opts[opt_name]

        if len(opt_value) > 0:
            opt_pairs.append("=".join([opt_name, opt_value]))
        else:
            opt_pairs.append(opt_name)

    write_out = " ".join(opt_pairs) + "\n"

    changes_required = read_in != write_out

    if args.check:
        if changes_required:
            logging.info("Check failed")
            sys.exit(1)
        else:
            logging.info("Check succeeded")
            sys.exit(0)

    if changes_required:
        with open(args.options_file, 'w') as kernel_opts_f:
            kernel_opts_f.writelines([
                write_out,
            ])
        
        logging.info("Wrote Kernel options changes")

if __name__ == '__main__':
    main()