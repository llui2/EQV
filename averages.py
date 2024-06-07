import matplotlib.pyplot as plt
import numpy as np

plt.rc('font', family='Times')
plt.rc('mathtext', fontset='cm')

# Read data from file
data = np.loadtxt('results/data/q.dat')

if data.ndim == 1:
    data = np.array([data])

MCS = [30, 100, 300, 1000, 3000, 10000, 30000, 100000]

TEMP = data[:, 0]
H = data[:, 1]
p = data[:, 2]
qself = data[:, 4:12]
q = data[:, 13:]

# Check unique values of H
H_values = np.unique(H)
p_values = np.unique(p)

# Dictionary of colors for each p value
colors = {0.0: '#E50D00', 0.15: '#E6038A', 0.3: '#AF06E7',
          0.5: '#1F09E8', 0.7: '#0D87E9', 0.85: '#10EABC', 1.0: '#14EB31'}

for i in range(len(H_values)):
    p_qself = [[] for x in range(len(p_values))]
    p_q = [[] for x in range(len(p_values))]

    for j in range(len(H)):
        for k in range(len(p_values)):
            if H[j] == H_values[i] and p[j] == p_values[k]:
                p_qself[k].append(qself[j])
                p_q[k].append(q[j])

    # Set up figure and subplots
    fig = plt.figure(figsize=(5, 5))
    ax = plt.subplot()
    plt.subplots_adjust(wspace=0, hspace=0, left=0.15,
                        top=0.85, right=0.9, bottom=0.1)

    ax.tick_params(direction='in', top=True, right=True)

    # Plot
    plt.title(f"$\\Gamma={H_values[i]}$", loc='right')

    for j in range(len(p_values)):
        ax.plot(MCS, p_qself[j][0], linestyle='-', linewidth=1, marker='x',
                markersize=3, color=colors[p_values[j]], label=f'p = {p_values[j]}')
        
        ax.plot(MCS, p_q[j][0], linestyle='--', linewidth=1, marker='x',
                markersize=3, color=colors[p_values[j]])

    ax.set_xlabel('MCS', fontfamily='Times')
    ax.set_ylabel(' ', fontfamily='Times')
    # ax.set_xlim(0, 6.00)
    ax.set_xscale('log')
    ax.set_ylim(0, 1)
    ax.yaxis.set_major_locator(plt.MaxNLocator(5))

    plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.18),
               fancybox=False, shadow=False, frameon=False, ncol=4)

    plt.margins(0, 10)

    dummy = f'{H_values[i]:.2f}'

    # Show plot
    plt.savefig(f'results/q_Γ{dummy[:1]+dummy[2:]}.pdf')
