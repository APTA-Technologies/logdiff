# Log Differencing Action

Logdiff takes the log output of your recent commit/push and highlights differences to the previous commit/push.
Rather than comparing the log files as text document, it builds a reference software model from the log files as a baseline for each comparsion.

## Quickstart by Example

Take a look at https://github.com/APTA-Technologies/logdiff-example for a minimal example configuration.

## Quickstart Guide

(1) Head over to logdiff.apta.tech to obtain an API key. It's used to store the previous software model and the comparision results. 

(2) Set up an action using `APTA-Technologies/logdiff@v1` e.g. on `push`. The logdiff action It takes a couple of parameters: `
	- tracefile` is the file generated by your test runs,
	-  `inifile` contains settings for `flexfringe`, the inference tool used for building reference software models. You can leave it at its default value (`edsm.ini`), read the documentation of flexfringe to get more fine control of the model, or contact us at APTA.
	- Lastely, it takes `apitoken` to ensure read/write access is confined to each users own repositories.
Your entry might look like this: 
```
      - name: Run logdiff
        id: logdiff
        uses: APTA-Technologies/logdiff@v1
        with:
          tracefile: logtrace.csv
          inifile: edsm.ini
          apitoken: ${{ secrets.LOGDIFF_API_KEY }}
```
The `logdiff action` requires write permissions in the folder with the `tracefile`.

(3) Ensure you generate the `tracefile` in the right input format. Ideally, a comma-separated CSV file with the following headers:

- `id` or multiple `id-X`, `id-Y`, etc.: These can be testcase names, user or session ids for the log events, or similar trace information. If multiple `id-X` fields are present, a single field is created by concatenation.
- `symb`: the actual event name being logged. 

(4) After running, the action will publish the following artifacts:

- a model as json file
- a trace-by-trace result file as csv
- a human-readable/interpreted result file as csv

## Interpreting the Output

The action publishes a couple of files as artifact. It includes a `inputname.csv.result`, which contains line-by-line information about each input trace.

```
Summary of logdiff run

Traces with unchanged behavior:	102
Traces with changed behavior:	5

Different behavior for trace ids (numeric, identifier):
{(3, 73a343b0), (57, ea75d912), (71, 00113763), (79, 23091ac0), (101, 3298111a)}

Average number of different events per trace: 1.6

Average depth of differences: 8 events

Events most commonly involved in difference: EV_ACTIVATE, EV_SUCCESS

Details of differences are stord in ev_traces.csv.result.

==========
Unchanged   97 / 102
Changed	    5 / 102
Total       102 / 102
==========

```

## Contact

You can reach us via email at hello at apta dot tech, or via @chrshmmmr on twitter, or by raising an issue here on github.



